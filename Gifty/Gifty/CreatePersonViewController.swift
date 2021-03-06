//
//  CreatePersonViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-27.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import GiftyBridge

protocol CreatePersonViewControllerDelegate {
    func didSaveChanges()
}

class CreatePersonViewController: CustomViewController {

    var delegate: CreatePersonViewControllerDelegate?
    
    private var person: Person?

    private var isUpdatePerson = false
    
    private var editsMade = false
    
    private var firstName: String? {
        didSet {
            editsMade = true
        }
    }
    
    private var lastName: String? {
        didSet {
            editsMade = true
        }
    }
    
    private var group: String? {
        didSet {
            editsMade = true
        }
    }
    
    private var dob: DateComponents?
    
    private var customTransitionDelegate = CustomTransitionDelegate()

    private var orderedEvents: [Event]?
    
    private var newEventIds = [String]()
    
    private lazy var profileImageView: CustomImageControl = {
        let imageControl = CustomImageControl()
        if let image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue) {
            imageControl.setDefaultImage(image)
        }
        imageControl.addTarget(self, action: #selector(profileImageTouchDown), for: .touchDown)
        imageControl.addTarget(self, action: #selector(profileImageTouchUpOutside), for: .touchUpOutside)
        imageControl.addTarget(self, action: #selector(profileImageTouchUpInside), for: .touchUpInside)
        imageControl.layer.masksToBounds = true
        imageControl.setContentMode(.scaleAspectFill) //<<<
        return imageControl
    }()
    
    private var profileImage: UIImage? {
        didSet {
            editsMade = true
        }
    }
    
    private var textFieldTV: PersonTFTableView!
    
    private var dropDown: DropDownTextField!
    
    private lazy var addFromContactLabel: ButtonTemplate = {
        var button = ButtonTemplate(frame: .zero)
        button.setTitle("+ add from contacts")
        button.titleLabel?.font = Theme.fonts.mediumText.font
        button.addTarget(self, action: #selector(didTapAddFromContactsLabel), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 0
        return button
    }()
    
    private var eventTableView: EventDisplayViewCreatePerson!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventDeleted(notification:)), name: Notifications.names.eventDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventCreated(notification:)), name: Notifications.names.newEventCreated.name, object: nil)
        
        self.title = "Add Person"
        
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTouched))
    
        self.navigationItem.leftBarButtonItem = backButton

        layoutSubviews()
    }
    
    //MARK: BACK BUTTON
    @objc func backButtonTouched() {
        
        if editsMade {
            
            backButtonAlert(for: self.person)
            
        } else {
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    private func backButtonAlert(for person: Person?) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: CustomErrors.createEvent.changesMade.description, preferredStyle: .alert)
        
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            
            if let currentPerson = person {
                //discard changes if update mode ELSE delete new entity
                if self.isUpdatePerson {
                    
                    for id in self.newEventIds {
                        if let event = ManagedObjectBuilder.getEventBy(uuid: id) {
                            print("Deleted Event \(id)")
                            event.managedObjectContext?.delete(event)
                        }
                    }
                    
                    currentPerson.managedObjectContext?.refresh(currentPerson, mergeChanges: false)
                    
                } else {
                    let events = currentPerson.event?.allObjects
                    
                    for event in events as! [Event] {
                        event.managedObjectContext?.delete(event)
                    }
                    currentPerson.managedObjectContext?.delete(currentPerson)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    private func layoutSubviews() {
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView)))
        
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let padx = isIpad ? view.bounds.width / 4 : pad
        let maxWidth = isIpad ? view.bounds.width / 2 : view.bounds.width - pad - pad
        
        
        profileImageView.frame = CGRect(x: padx, y: safeAreaTop + navHeight + pad, width: 150, height: 150)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        view.addSubview(profileImageView)
        
        let tfx = profileImageView.frame.maxX + pad
        textFieldTV = PersonTFTableView(frame: CGRect(x: tfx, y: profileImageView.frame.origin.y, width: maxWidth - profileImageView.frame.width - pad, height: profileImageView.frame.height * 0.6666))
        textFieldTV.delegate = self
        view.addSubview(textFieldTV)
        
        let dropDownFrame = CGRect(x: tfx, y: textFieldTV.frame.maxY, width: textFieldTV.frame.width, height: profileImageView.bounds.height * 0.3333)
        
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Group", options: SettingsHandler.shared.groups)
        
        dropDown.delegate = self
        
        view.addSubview(dropDown)
        
        view.addSubview(addFromContactLabel)
        
        addFromContactLabel.frame = CGRect(x: padx, y: profileImageView.frame.maxY + pad, width: 150, height: 17)
        
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let eventHeight = view.bounds.height - addFromContactLabel.frame.maxY - pad - tabBarHeight
        
        eventTableView = EventDisplayViewCreatePerson(frame: CGRect(x: 0, y: addFromContactLabel.frame.maxY + pad, width: view.bounds.width, height: eventHeight))
        
        eventTableView.delegate = self
        
        view.addSubview(eventTableView)
        
        if self.person != nil {
            setupViewsForUpdatePerson()
        }
        
    }
    
    func setupForEditPerson(_ person: Person) {
        self.person = person
        self.isUpdatePerson = true
    }
    
    private func updateEventDisplayViewWithOrderedEvents() {
        if let unorderedEvents = self.person?.event?.allObjects as? [Event] {
            //correctly order the events by date
            let orderedEvents = unorderedEvents.sorted(by: { (eventA, eventB) -> Bool in
                eventA.date?.compare(eventB.date! as Date) == ComparisonResult.orderedAscending
            })
            self.eventTableView.setupDataSources(for: orderedEvents)
        }
    }
    
    @objc
    func eventDeleted(notification: NSNotification) {
        self.updateEventDisplayViewWithOrderedEvents()
    }
    
    //MARK: Update views if notification received from Quick Add Event
    @objc
    func eventCreated(notification: NSNotification) {
        guard let personId = notification.userInfo?["personId"] as? String else { return }
        guard let createEventState = notification.userInfo?["createEventState"] as? String else { return }
        if createEventState == "newEventToBeAssigned" && personId == self.person?.id {
            self.updateEventDisplayViewWithOrderedEvents()
        }
    }

    //drop keyboard if editing textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//MARK: UPDATE PERSON SETUP
    
extension CreatePersonViewController {
    
    func setupViewsForUpdatePerson() {
        
        guard let currentPerson = self.person else {
            print("No person to update")
            self.navigationController?.popViewController(animated: true)
            return
        }

        self.navigationItem.title = currentPerson.fullName
        
        if currentPerson.profileImage != nil {
            if let image = UIImage(data: currentPerson.profileImage! as Data) {
                self.profileImageView.setImage(image)
                self.profileImage = image
            }
        }
        textFieldTV.updateWith(firstName: currentPerson.firstName, lastName: currentPerson.lastName)
        
        dropDown.setTitle(text: currentPerson.group!)
        self.group = person?.group
        
        eventTableView.changeSaveButtonText("UPDATE")
        
        updateEventDisplayViewWithOrderedEvents()
        editsMade = false
    }
    
    @objc func didTapBackgroundView() {
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
}


//MARK: ADD FROM CONTACTS
extension CreatePersonViewController {
    
    @objc func didTapAddFromContactsLabel() {

        if person != nil {
            let alertControntroller = UIAlertController(title: "Are you sure?", message: "This action could change the name of your person", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.addPersonFromContacts()
            })
            alertControntroller.addAction(okAction)
            alertControntroller.addAction(cancelAction)
            self.present(alertControntroller, animated: true, completion: nil)
        } else {
            addPersonFromContacts()
        }
    }
        
    func addPersonFromContacts() {
        print("add from contacts")
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == .notDetermined {
            
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, error) in
                if success {
                    self.launchContacts()
                }
            })
        } else if authStatus == .authorized {
            self.launchContacts()
        }
    }
    
    func launchContacts() {

        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
}


//MARK: ContactPicker delegate methods
extension CreatePersonViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        if contact.imageDataAvailable, let imageData = contact.imageData {
            if let image = UIImage(data: imageData) {
                profileImageView.setImage(image)
            }
        }
        textFieldTV.updateWith(firstName: contact.givenName, lastName: contact.familyName)
        dismiss(animated: true) { 
            if let dob = contact.birthday {
                self.dob = dob
            }
        }
    }
    
    fileprivate func birthdayAlert() {
        let alertController = UIAlertController(title: "Create Birthday?", message: "Your contact has a birth date stored in it. Would you like to create a birthday event for them?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("Create new event for birth date \(String(describing: self.dob))")
            
            //create vc for segue and put in the dob
            guard let d = self.dob, let birthdate = Calendar.current.date(from: d) else {
                print("could not create birthdate from components")
                return
            }

            self.person = self.person ?? self.createPersonEntity()
            
            let dest = CreateEventViewController()
            dest.delegate = self
            if dest.createBirthday(dob: birthdate, for: self.person!) {
                self.navigationController?.pushViewController(dest, animated: true)
            } else {
                print("Could not create birthday for date (leap year.)")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


//MARK: ImagePicker delegate methods
extension CreatePersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func profileImageTouchDown() {
        if self.profileImageView.isImageSelected == false {
            if let image = UIImage(named: ImageNames.profileImagePlaceHolderTouched.rawValue) {
                self.profileImageView.setDefaultImage(image)
            }
        }
    }
    
    @objc func profileImageTouchUpInside() {
        
        returnToDefaultProfileImage()
        
        let options = ["Camera", "Photo library"]
        ActionSheetService.actionSheet(with: options, presentedIn: self) { (option) in
            switch option {
            case options[0]: self.launchCameraPicker()
            case options[1]: self.launchImagePicker()
            default: print("this should not be reached")
            }
        }
    }
    
    @objc func profileImageTouchUpOutside() {
        returnToDefaultProfileImage()
    }
    
    private func returnToDefaultProfileImage() {
        if self.profileImageView.isImageSelected == false {
            if let image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue) {
                self.profileImageView.setDefaultImage(image)
            }
        }
    }
    
    
    private func launchImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    private func launchCameraPicker() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            print("Camera entered")
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.delegate = self
            
            present(picker, animated: true, completion: nil)
        } else {
            AlertService.okAlert(title: "No Camera", message: "This device has no camera", in: self)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            if let scaledImage = UIImage.scaleImage(image: selectedImage!, toWidth: profileImageView.frame.width, andHeight: profileImageView.frame.height) {
                self.profileImageView.setImage(scaledImage)
                self.profileImage = scaledImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: DropDown delegate methods
extension CreatePersonViewController: DropDownTextFieldDelegate {
    func dropDownWillAnimate(down: Bool) {
        if down {
            view.bringSubview(toFront: dropDown)
        } else {
            view.insertSubview(dropDown, aboveSubview: backgroundView)
        }
    }
    
    func optionSelected(option: String) {
        self.group = option
        print("updated group in vc to \(group ?? "")")
    }
}

//MARK: TextFieldTableView delegate methods
extension CreatePersonViewController: PersonTFTableViewDelegate {
    func didUpdateFirstName(string: String) {
        if person != nil {
            if self.firstName == nil {
                self.firstName = string
            } else if self.firstName != string {
                showNameChangeAlert(string: string, isfirstName: true)
            }
        } else {
            self.firstName = string
        }
    }
    
    func didUpdateLastName(string: String) {
        if self.person != nil {
            if self.lastName == nil {
                self.lastName = string
            } else if self.lastName != string {
                showNameChangeAlert(string: string, isfirstName: false)
            }
        } else {
            self.lastName = string
            
        }
    }
    
    func showNameChangeAlert(string: String, isfirstName: Bool) {
        let alertControntroller = UIAlertController(title: "Name Change!", message: CustomErrors.createPerson.nameChange.description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if isfirstName {
                self.firstName = string
            } else {
                self.lastName = string
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            if isfirstName {
                self.textFieldTV.updateWith(firstName: self.firstName, lastName: nil)
            } else {
                self.textFieldTV.updateWith(firstName: nil, lastName: self.lastName)
            }
            self.dismiss(animated: true, completion: nil)
        })
        alertControntroller.addAction(okAction)
        alertControntroller.addAction(cancelAction)
        self.present(alertControntroller, animated: true, completion: nil)
    }
}

//MARK: Event Table View Delegate
extension CreatePersonViewController: EventTableViewDelegate {
    
    func didTouchEdit(for event: Event) {
        print("Edit existing event")
        let destination = CreateEventViewController()
        destination.eventToBeEdited = event
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func didTouchDelete(for event: Event, at indexPath: IndexPath) {
        guard let dateString = event.dateString else { return }
        
        //present alert
        let alert = UIAlertController(title: "Are you sure?", message: CustomErrors.createPerson.deletePerson.description, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            //delete all assigned gifts
            if let assignedGifts = GiftFRC.getGifts(for: event) {
                for gift in assignedGifts {
                    gift.managedObjectContext?.delete(gift)
                }
            }
            //delete event
            event.managedObjectContext?.delete(event)
            
            //save changes
            ManagedObjectBuilder.saveChanges(dataPersistence: DataPersistenceService.shared) { (success) in
                if success {
                    //send notification
                    let userInfo = ["EventDisplayViewId": self.eventTableView.id, "dateString": dateString]
                    DispatchQueueHandler.notification.queue.async {
                        NotificationCenter.default.post(name: Notifications.names.eventDeleted.name,
                                                        object: nil,
                                                        userInfo: userInfo)
                    }
                }
            }
            self.eventTableView.tableViewRemoveEvent(at: indexPath)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTouchBudget(for event: Event) {
        let overlayVC = OverlayEventBudgetViewController()
        self.transitioningDelegate = self.customTransitionDelegate
        overlayVC.transitioningDelegate = self.customTransitionDelegate
        overlayVC.modalPresentationStyle = .custom
        overlayVC.event = event
        
        self.present(overlayVC, animated: true, completion: nil)
        PopUpManager.popUpShowing = true
    }
    
    func didTouchGifts(for event: Event) {
        let overlayVC = OverlayGiftViewController()
        self.transitioningDelegate = self.customTransitionDelegate
        overlayVC.transitioningDelegate = self.customTransitionDelegate
        overlayVC.modalPresentationStyle = .custom
        overlayVC.delegate = self
        overlayVC.event = event
        
        self.present(overlayVC, animated: true, completion: nil)
        PopUpManager.popUpShowing = true
    }
    
    func didTouchReminder(for event: Event) {
        let dest = CENNotificationsVC()
        dest.event = event
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(dest, animated: true)
        }
    }
    
}

//MARK: SAVE Button Delegate

extension CreatePersonViewController: EventDisplayViewPersonDelegate {
    
    func didTouchSaveButton() {
        
        print("Save touched")
        
        checkSufficientInformationToSave { (success) in
            if success {
                //UPDATE EXISTING PERSON
                if let p = self.person {
                    
                    ManagedObjectBuilder.updatePerson(person: p, firstName: self.firstName!, lastName: self.lastName, group: self.group!, profileImage: self.profileImage, completion: { (success, person) in
                        
                        if success {
                            ManagedObjectBuilder.saveChanges(dataPersistence: DataPersistenceService.shared, completion: { (success) in
                                if !success {
                                    print("Error occured during save")
                                }
                                if self.delegate != nil {
                                    self.delegate?.didSaveChanges()
                                }
                                navigationController?.popViewController(animated: true)
                            })
                        } else {
                            print("Could not update managed object")
                        }
                    })
                } else {
                    
                    //SAVE NEW PERSON (No event added)
                    ManagedObjectBuilder.createPerson(firstName: self.firstName!, lastName: self.lastName, group: group!, profileImage: self.profileImage, completion: { (success, person) in
                        if success {
                            guard let p = person else { return }
                            
                            self.person = p
                            
                            ManagedObjectBuilder.saveChanges(dataPersistence: DataPersistenceService.shared, completion: { (success) in
                                if success {
                                    
                                    print("Saved new person successfully")
                                    if self.delegate != nil {
                                        self.delegate?.didSaveChanges()
                                    }
                                    if dob != nil && !p.hasBirthday() {
                                        self.birthdayAlert()
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    private func checkSufficientInformationToSave(completion: (_ success: Bool) -> Void) {
        guard firstName != nil && firstName != "" else {
            completion(false)
            insufficientInfoAlert(message: CustomErrors.createPerson.noFirstName.description)
            return
        }
        
        guard group != nil && group != "" else {
            completion(false)
            insufficientInfoAlert(message: CustomErrors.createPerson.noGroup.description)
            return
        }
        
        if isUpdatePerson {
            guard self.person != nil else {
                completion(false)
                print(CustomErrors.createPerson.noPerson.description)
                return
            }
        }
        
        completion(true)
    }
    
    private func insufficientInfoAlert(message: String) {
        AlertService.okAlert(title: "Insufficient Information", message: message, in: self)
    }

    func didTouchAddEventButton() {
        print("Add new event!")
        
        self.person = self.person ?? createPersonEntity()
        
        if dob != nil && !self.person!.hasBirthday() {
            self.birthdayAlert()
        } else {
            
            let destination = CreateEventViewController()
            destination.delegate = self
            destination.createEventState = CreateEventState.newEventForPerson
            destination.person = self.person
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    private func createPersonEntity() -> Person? {
        
        var newPerson: Person?
        
        checkSufficientInformationToSave { (success) in
            if success {
                ManagedObjectBuilder.createPerson(firstName: firstName!, lastName: lastName, group: group!, profileImage: profileImage) { (success, person) in
                    if success {
                        newPerson = person
                    }
                }
            }
        }
        return newPerson
    }
    
    //drop down keyboard if textfield is editing.
    func touchesBegan() {
        self.view.endEditing(true)
    }
}

//MARK: Create Event Delegate
extension CreatePersonViewController: CreateEventViewControllerDelegate {
    
    func eventAddedToPerson(uuid: String) {
    
        print("CreateEventVCDelegate called")
        self.newEventIds.append(uuid)
        editsMade = true
        updateEventDisplayViewWithOrderedEvents()
    }
}

extension CreatePersonViewController : OverlayGiftViewControllerDelegate {
    
    func segueToOverlayBudgetViewController(event: Event) {
        self.didTouchBudget(for: event)
    }
    
    func segueToGiftVCForEdit(with gift: Gift) {
        
        let dest = CreateGiftViewController()
        dest.setupForEditMode(with: gift)
        self.navigationController?.pushViewController(dest, animated: true)
    }
}
