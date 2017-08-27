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

protocol CreatePersonViewControllerDelegate {
    func didSaveChanges()
}

class CreatePersonViewController: CustomViewController {

    var delegate: CreatePersonViewControllerDelegate?
    
    var person: Person? = nil

    var isUpdatePerson = false
    
    var firstName: String?
    var lastName: String?
    var group: String?
    var dob: DateComponents?

    var orderedEvents: [Event]?
    
    var newEventIds = [String]()
    
    lazy var profileImageView: CustomImageControl = {
        let imageControl = CustomImageControl()
        imageControl.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue)
        imageControl.imageView.contentMode = .scaleAspectFill
        imageControl.addTarget(self, action: #selector(profileImageTouchDown), for: .touchDown)
        imageControl.addTarget(self, action: #selector(profileImageTouchUpInside), for: .touchUpInside)
        imageControl.layer.masksToBounds = true
        return imageControl
    }()
    
    var profileImage: UIImage?
    
    var textFieldTV: PersonTFTableView!
    
    var dropDown: DropDownTextField!
    
    lazy var addFromContactLabel: ButtonTemplate = {
        var button = ButtonTemplate(frame: .zero, title: "+ add from contacts")
        button.titleLabel?.font = Theme.fonts.mediumText.font
        button.addTarget(self, action: #selector(didTapAddFromContactsLabel), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 0
        return button
    }()
    
    var saveButton: ButtonTemplate!
    
    var eventTableView: EventDisplayViewCreatePerson!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Person"
        
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue)
            , style: .plain, target: self, action: #selector(backButtonTouched))
        
        self.navigationItem.leftBarButtonItem = backButton

        layoutSubviews()
    }
    
    //MARK: BACK BUTTON
    func backButtonTouched() {
        
        if let currentPerson = self.person, currentPerson.hasChanges {
            
            backButtonAlert(for: currentPerson)
            
        } else if variablesWereSet() && !isUpdatePerson {
            
            backButtonAlert(for: nil)
            
        } else {
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    private func backButtonAlert(for person: Person?) {
        
        let alertController = UIAlertController(title: "Unsaved Changes", message: "If you continue to navigate away, you will lose your unsaved changes", preferredStyle: .alert)
        
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            
            if let currentPerson = person {
                //discard changes to person
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //do nothing
        })
        
        alertController.addAction(continueAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    private func variablesWereSet() -> Bool {
        
        guard self.firstName == nil else {
     
            return true
        
        }

        guard self.lastName == nil else {
         
            return true
        
        }
        
        guard self.group == nil else {
         
            return true
        
        }
        
        guard self.profileImage == nil else {
         
            return true
        
        }
        
        return false
    }
    
    private func layoutSubviews() {
        
        self.backgroundView.isUserInteractionEnabled = true
        
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView)))
        
        var currMaxX: CGFloat = 0
        
        var currMaxY: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
         
            currMaxY = navHeight + UIApplication.shared.statusBarFrame.height + pad
            
            profileImageView.frame = CGRect(x: pad, y: currMaxY, width: 150, height: 150)
        
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        view.addSubview(profileImageView)
        
        currMaxX = pad + profileImageView.frame.width + pad
        
        textFieldTV = PersonTFTableView(frame: CGRect(x: currMaxX, y: currMaxY, width: view.bounds.width - currMaxX - pad, height: profileImageView.bounds.height * 0.6666))
        
        textFieldTV.delegate = self
        
        view.addSubview(textFieldTV)
        
        currMaxY += textFieldTV.frame.height
        
        let dropDownFrame = CGRect(x: currMaxX, y: currMaxY, width: view.bounds.width - currMaxX - pad, height: profileImageView.bounds.height * 0.3333)
        
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Group", options: ["Family", "Friends", "Colleagues"])
        
        dropDown.delegate = self
        
        view.addSubview(dropDown)

        currMaxY += profileImageView.bounds.height * 0.3333 + pad
        
        view.addSubview(addFromContactLabel)
        
        addFromContactLabel.frame = CGRect(x: pad, y: currMaxY, width: 150, height: 17)
        
        
        currMaxY += addFromContactLabel.frame.height + pad
        
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let eventHeight = view.bounds.height - currMaxY - tabBarHeight
        
        eventTableView = EventDisplayViewCreatePerson(frame: CGRect(x: 0, y: currMaxY, width: view.bounds.width, height: eventHeight))
        
        eventTableView.delegate = self
        
        view.addSubview(eventTableView)
        
        let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
        
        saveButton = ButtonTemplate(frame: buttonframe, title: "SAVE")
        
        saveButton.delegate = self
        
        view.addSubview(saveButton)
        
        if isUpdatePerson {
        
            setupViewsForUpdatePerson()
        
        }
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
        
        if currentPerson.profileImage != nil {
            self.profileImageView.imageView.image = UIImage(data: currentPerson.profileImage! as Data)
            self.profileImageView.isImageSelected = true
            self.profileImage = profileImageView.imageView.image
        }
        textFieldTV.updateWith(firstName: currentPerson.firstName, lastName: currentPerson.lastName)
        
        dropDown.setTitle(text: currentPerson.group!)
        self.group = person?.group
        
        updateEventDisplayViewWithOrderedEvents()
    }
    
    func didTapBackgroundView() {
        textFieldTV.finishEditing()
        dropDown.finishEditingTextField()
    }
}


//MARK: ADD FROM CONTACTS
extension CreatePersonViewController {
    
    func didTapAddFromContactsLabel() {
        
        if isUpdatePerson {
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
        
        if contact.imageDataAvailable {
            let imageData = contact.imageData
            let image = UIImage(data: imageData!)
            profileImageView.imageView.image = image
        }
        textFieldTV.updateWith(firstName: contact.givenName, lastName: contact.familyName)
        dismiss(animated: true) { 
            if let dob = contact.birthday {
                let alertController = UIAlertController(title: "Create Birthday?", message: "Your contact has a birth date stored in it. Would you like to create a birthday event for them?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("Create new event for birth date \(dob)")
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


//MARK: ImagePicker delegate methods
extension CreatePersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func profileImageTouchDown() {
        if self.profileImageView.isImageSelected == false {
            self.profileImageView.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolderTouched.rawValue)
        }
    }
    
    func profileImageTouchUpInside() {
        
        if self.profileImageView.isImageSelected == false {
            self.profileImageView.imageView.image = UIImage(named: ImageNames.profileImagePlaceHolder.rawValue)
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
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
            let scaledImage = UIImage.scaleImage(image: selectedImage!, toWidth: profileImageView.frame.width, andHeight: profileImageView.frame.height)
            self.profileImageView.imageView.image = scaledImage
            self.profileImageView.isImageSelected = true
            self.profileImage = profileImageView.imageView.image
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

        if isUpdatePerson {
            if self.firstName == nil {
                self.firstName = string
            } else if self.firstName != string {
                showNameChangeAlert(string: string, isfirstName: true)
            }
        } else {
            self.firstName = string
        }
        print("updated first name in vc to \(firstName ?? "")")
    }
    
    func didUpdateLastName(string: String) {
        
        if isUpdatePerson {
            if self.lastName == nil {
                self.lastName = string
            } else if self.lastName != string {
                showNameChangeAlert(string: string, isfirstName: false)
            }
        } else {
            self.lastName = string
            
        }
        print("updated last name in vc to \(lastName ?? "")")
    }
    
    func showNameChangeAlert(string: String, isfirstName: Bool) {
        let alertControntroller = UIAlertController(title: "Name Change", message: "This action could change the name of your person", preferredStyle: .alert)
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

    func didTouchEditEvent(event: Event) {
        
        print("Edit existing event")
        let destination = CreateEventViewController()
        destination.delegate = self
        destination.createEventState = CreateEventState.updateEventForPerson
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func didTouchDeleteEvent(event: Event) {
        event.managedObjectContext?.delete(event)
        
        ManagedObjectBuilder.saveChanges { (success) in
            //send notification
            guard let dateString = event.dateString else { return }
            let userInfo = ["EventDisplayViewId": self.eventTableView.id, "dateString": dateString]
            NotificationCenter.default.post(name: Notifications.Names.eventDeleted.Name, object: nil, userInfo: userInfo)
        }
    }
    
}

//MARK: Add Button Delegate

extension CreatePersonViewController: EventDisplayViewPersonDelegate {

    func didTouchAddEventButton() {
        print("Add new event!")
        
        let destination = CreateEventViewController()
        destination.delegate = self
        destination.createEventState = CreateEventState.newEventForPerson
        
        if isUpdatePerson {
            //create vc and assign person
            destination.person = self.person
        } else {
            //create 'unsaved' person then create vc and assign
            let newPerson = createPersonEntity()
            self.person = newPerson
            destination.person = newPerson
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func createPersonEntity() -> Person? {
        
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
}

//MARK: Create Event Delegate
extension CreatePersonViewController: CreateEventViewControllerDelegate {
    
    func eventAddedToPerson(uuid: String) {
    
        print("CreateEventVCDelegate called")
        self.newEventIds.append(uuid)
        updateEventDisplayViewWithOrderedEvents()
    }
    
    func updateEventDisplayViewWithOrderedEvents() {
        if let events = self.person?.event?.allObjects as? [Event] {
            
            //TO DO: correctly order the events by date
            self.eventTableView.orderedEvents = events
        }
    }
    
}


//MARK: SAVE BUTTON
extension CreatePersonViewController: ButtonTemplateDelegate {
    
    func buttonWasTouched() {
        
        print("Save touched")

        checkSufficientInformationToSave { (success) in
            if success {
                //UPDATE EXISTING PERSON
                if self.person != nil {
                    
                    ManagedObjectBuilder.updatePerson(person: self.person!, firstName: self.firstName!, lastName: self.lastName, group: self.group!, profileImage: self.profileImage, completion: { (success, person) in
                        
                        if success {
                            ManagedObjectBuilder.saveChanges(completion: { (success) in
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
                            ManagedObjectBuilder.saveChanges(completion: { (success) in
                                if success {
                                    print("Saved new person successfully")
                                    if self.delegate != nil {
                                        self.delegate?.didSaveChanges()
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }
                            })
                        }
                    })
                }
            }
        }
    
        //SAVE TEMP PERSON (event added)
    }
    
    func checkSufficientInformationToSave(completion: (_ success: Bool) -> Void) {
        guard firstName != nil && firstName != "" else {
            completion(false)
            insufficientInfoAlert(message: "Please add a first name")
            return
        }
        
        guard group != nil && group != "" else {
            completion(false)
            insufficientInfoAlert(message: "Please add a group")
            return
        }
        
        if isUpdatePerson {
            guard self.person != nil else {
                completion(false)
                print("No person to update")
                return
            }
        }
        
        completion(true)
    }
    
    private func insufficientInfoAlert(message: String) {
        
        let alertController = UIAlertController(title: "Insufficient Information", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //do nothing
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
