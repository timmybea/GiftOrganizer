//
//  CreateEventViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge
import CoreData

protocol CreateEventViewControllerDelegate {
    func eventAddedToPerson(uuid: String)
}

//MARK: Create Event State ENUM
enum CreateEventState: String {
    case newEventForPerson
    case updateEventForPerson
    case newEventToBeAssigned
}

class CreateEventViewController: CustomViewController {
    
    //MARK: Logic properties
    var createEventState: CreateEventState?
    
    var eventToBeEdited: Event? {
        didSet {
            createEventState = .updateEventForPerson
        }
    }
    private var editsMade = false
    
    var delegate: CreateEventViewControllerDelegate?
    
    var person: Person? {
        didSet {
            print("CreateEvent: Person assigned to \(String(describing: person?.fullName!))")
            if createEventState == .newEventToBeAssigned {
                editsMade = true
            }
        }
    }
    
    private var eventType: String? {
        didSet {
            print("update event type to \(String(describing: eventType))")
            editsMade = true
        }
    }
    
    private var eventDate: Date? {
        didSet {
            print("event date changed to \(String(describing: eventDate))")
            addDateView.updateLabel(with: eventDate)
            editsMade = true
        }
    }
    
    private var tempEventId: String?
    
    private var isRecurringEvent = false {
        didSet {
            addDateView.recurringEventSwitch.setOn(isRecurringEvent, animated: true)
            editsMade = true
        }
    }
    
    private var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    private var navHeight: CGFloat! {
        return navigationController?.navigationBar.frame.height
    }
    
    private let statusHeight = UIApplication.shared.statusBarFrame.height
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(sender:)))
    
    //MARK: UI Objects
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.layer.masksToBounds = false
        sv.backgroundColor = UIColor.clear
        sv.isPagingEnabled = false
        return sv
    }()
    
    private var scrollViewFrame: CGRect!
    
    private var dropDown: DropDownTextField!
    
    private var addDateView: AddDateView!
    
    private var addGiftView: AddGiftView!
    
    private var autoCompletePerson: AutoCompletePerson?
    
    private var budgetLabel: UILabel = {
        let l = Theme.createMediumLabel()
        l.text = "Set Budget"
        return l
    }()
    
    private var budgetView: BudgetView!
    private var budgetViewFrame: CGRect!
    
    private var saveButton: ButtonTemplate!
    
    //MARK: VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(personDeleted(sender:)),
                                               name: Notifications.names.personDeleted.name,
                                               object: nil)
        
        self.title = createEventState == .updateEventForPerson ? "Edit Event" : "Add Event"
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTouched))
        
        self.navigationItem.leftBarButtonItem = backButton

        subviewLayout()
    }
    
    private func subviewLayout() {
        //saveButton
        let buttonframe = CGRect(x: pad,
                                 y: view.bounds.height - tabBarHeight - pad - 35,
                                 width: view.bounds.width - pad - pad,
                                 height: 35)
        saveButton = ButtonTemplate(frame: buttonframe)
        saveButton.setTitle("SAVE")
        saveButton.addBorder(with: UIColor.white)
        saveButton.addTarget(self, action: #selector(saveButtonTouched(sender:)), for: .touchUpInside)
        view.addSubview(saveButton)
        
        //scrollView
        scrollViewFrame = CGRect(x: pad,
                                 y: navHeight + statusHeight + pad,
                                 width: view.bounds.width - pad - pad,
                                 height: view.bounds.height - navHeight - statusHeight - pad - tabBarHeight - pad - 35)
        
        scrollView.frame = scrollViewFrame
        view.addSubview(scrollView)
        

        if createEventState == .newEventToBeAssigned {
            //autoCompletePerson
            let personLabel = Theme.createMediumLabel()
            personLabel.frame = CGRect(x: 0,
                                       y: 0,
                                       width: scrollView.bounds.width,
                                       height: 25)
            personLabel.text = "Set Person"
            scrollView.addSubview(personLabel)
            
            autoCompletePerson = AutoCompletePerson(frame: CGRect(x: 0,
                                                                  y: personLabel.frame.maxY + pad,
                                                                  width: scrollView.bounds.width,
                                                                  height: 100))
            guard let autoComplete = autoCompletePerson else { return }
            autoComplete.autoCompleteTF.autocompleteDelegate = self
            scrollView.addSubview(autoComplete)
            
            //dropDown
            let dropDownFrame = CGRect(x: 0,
                                       y: autoComplete.frame.maxY + pad,
                                       width: scrollView.bounds.width,
                                       height: 40)
            dropDown = DropDownTextField(frame: dropDownFrame, title: "Celebration Type", options: SettingsHandler.shared.celebrations)
            dropDown.delegate = self
            scrollView.addSubview(dropDown)
            
        } else {
            //dropDown
            let dropDownFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: 40)
            dropDown = DropDownTextField(frame: dropDownFrame, title: "Celebration Type", options: SettingsHandler.shared.celebrations)
            dropDown.delegate = self
            scrollView.addSubview(dropDown)
        }
        
        //addDateView
        addDateView = AddDateView(frame: CGRect(x: 0,
                                                y: dropDown.frame.minY + 40 + (2 * pad),
                                                width: scrollView.bounds.width,
                                                height: 30))
        scrollView.addSubview(addDateView)
        addDateView.delegate = self
        
        //Add gift view
        self.addGiftView = AddGiftView(frame: CGRect(x: 0,
                                                     y: addDateView.frame.maxY + (2 * pad),
                                                     width: scrollView.bounds.width,
                                                     height: AddGiftView.headerHeight))
        scrollView.addSubview(addGiftView)
        self.addGiftView.delegate = self
        
        //budgetLabel
        budgetLabel.frame = CGRect(x: 0,
                                   y: addGiftView.frame.maxY + pad,
                                   width: scrollView.bounds.width,
                                   height: 25)
        scrollView.addSubview(budgetLabel)
        
        //budgetView
        budgetView = BudgetView(frame: CGRect(x: 0,
                                              y: budgetLabel.frame.maxY + pad,
                                              width: scrollView.bounds.width,
                                              height: 60))
        budgetView.delegate = self
        scrollView.addSubview(budgetView)

        //Set content size for scroll view
        let contentHeight = budgetView.frame.maxY + (2 * pad)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentHeight)

        if createEventState == .updateEventForPerson {
            setupEventDataForEdit()
        }
    }
    
    private func setupEventDataForEdit() {
        
        guard let currentEvent = self.eventToBeEdited else {
            print("No event to update")
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.person = currentEvent.person
        self.navigationItem.title = "Event for \(currentEvent.person!.firstName!)"
        
        self.dropDown.setTitle(text: currentEvent.type!)
        self.eventType = currentEvent.type!
        
        self.eventDate = currentEvent.date!
        
        self.isRecurringEvent = true //<<< TEMPORARY HARDCODE
        
        if let gifts = GiftFRC.getGifts(for: currentEvent) {
            self.addGiftView.setGifts(gifts)
        }
        
        budgetView.setTo(amount: currentEvent.budgetAmt)
        
        self.saveButton.setTitle("UPDATE")
        
        self.editsMade = false
    }
    
    @objc
    func didTapBackground(sender: UITapGestureRecognizer) {
        guard let acPerson = autoCompletePerson else { return }
        if acPerson.autoCompleteTF.isEditing {
            autoCompletePerson?.endEditing(true)
        }
    }
    
    private func createAlertForError(_ error: CustomErrors.createEvent) {
        let alertController = UIAlertController(title: "Incomplete event", message: error.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Person Deleted Notification
    @objc
    func personDeleted(sender: Notification) {
        //get person from sender
        if let person = self.person ?? self.eventToBeEdited?.person {
            if let senderId = sender.userInfo?["personId"] as? String, senderId == person.id {
                navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    @objc
    func handleKeyboardNotification(sender: Notification) {
        guard tabBarController?.selectedIndex == 0 else { return }
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
        if sender.name == Notification.Name.UIKeyboardWillShow {
            //keyboard up
            scrollView.frame = CGRect(x: pad,
                                      y: navHeight + statusHeight + pad,
                                      width: view.bounds.width - pad - pad,
                                      height: view.bounds.height - navHeight - statusHeight - pad - keyboardFrame.height - pad)
            
            //scroll to bottom
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
            scrollView.addGestureRecognizer(tapGesture)
        } else {
            scrollView.frame = scrollViewFrame
            scrollView.removeGestureRecognizer(tapGesture)
        }
    }
    
    //drop keyboard if editing textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: check sufficient information to build event
    func checkSufficientInformationToCreateEvent(completion: (_ success: Bool, _ error: CustomErrors.createEvent?) -> Void) {
        
        guard self.eventType != nil else {
            completion(false, CustomErrors.createEvent.noEventType)
            return
        }
        
        guard self.eventDate != nil else {
            completion(false, CustomErrors.createEvent.noDate)
            return
        }
        
        if createEventState != CreateEventState.updateEventForPerson {
            guard self.person != nil else {
                completion(false, CustomErrors.createEvent.personIsNil)
                return
            }
        }
        completion(true, nil)
    }
}

//MARK: Drop down textfield delegate
extension CreateEventViewController: DropDownTextFieldDelegate {
    
    func dropDownWillAnimate(down: Bool) {
        if down {
            scrollView.bringSubview(toFront: dropDown)
        } else {
            scrollView.sendSubview(toBack: dropDown)
        }
    }
    
    func optionSelected(option: String) {
        self.eventType = option
        print("event selected: \(String(describing: self.eventType))")
    }
}

//MARK: Back button touched
extension CreateEventViewController {
    
    @objc func backButtonTouched() {
        //check if there are changes and send alert
        if editsMade {
            let alert = UIAlertController(title: "Are you sure?", message: CustomErrors.createEvent.changesMade.description, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                if self.eventToBeEdited == nil && self.tempEventId != nil {
                    self.addGiftView.removeEventIdFromAllGifts()
                }
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //do nothing
            })
            alert.addAction(continueAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: AddDateViewDelegate Methods
extension CreateEventViewController: AddDateViewDelegate {
    
    func addDateViewWasTouched() {
        let destination = DatePickerViewController()
        destination.delegate = self
        if self.eventDate != nil {
            destination.initialDate = self.eventDate
            destination.selectedDate = eventDate!
        }
        
        self.navigationController?.pushViewController(destination, animated: true)
    }

    func switchChanged(recurring: Bool) {
        
        if recurring {
            self.isRecurringEvent = true
        } else {
            self.isRecurringEvent = false
        }
        print("Is recurring changed: \(self.isRecurringEvent)")
    }
}

//MARK: DatePickerViewControllerDelegate Methods
extension CreateEventViewController: DatePickerViewControllerDelegate {
    
    func didSetDate(_ date: Date?) {
        self.eventDate = date
    }
    
}


//MARK: AddGiftDelegate
extension CreateEventViewController: AddGiftViewDelegate {
   
    func addGiftViewWasTouched() {
        
        guard let p = self.person else { return }
        let destination = SelectGiftViewController()
        destination.delegate = self
        destination.person = p

        navigationController?.pushViewController(destination, animated: true)

    }
    
    func needsToResize(to height: CGFloat) {
        self.addGiftView.frame.size.height = height
        UIView.animate(withDuration: 0.1, animations: {
            self.budgetLabel.frame.origin.y = self.addGiftView.frame.maxY + pad
            self.budgetView.frame.origin.y = self.budgetLabel.frame.maxY + pad
        }) { (complete) in
            self.addGiftView.setupTableView()
        }
        editsMade = true
    }

}

//MARK: SAVE Method
extension CreateEventViewController {
    
    @objc
    func saveButtonTouched(sender: UIButton) {
        checkSufficientInformationToCreateEvent(completion: { (success, error) in
            if success {
                if self.createEventState == CreateEventState.updateEventForPerson {
                    
                    //update existing event and save
                    guard let currEvent = self.eventToBeEdited else { return }
                    
                    let oldDate = currEvent.dateString
                    
                    let eb = EventBuilder.edit(event: currEvent)
                    eb.addType(self.eventType!)
                    eb.addDate(self.eventDate!)
                    eb.addBudget(self.budgetView.getBudgetAmount())
                    
                    guard let dateString = currEvent.dateString else { return }
                    let createUserInfo = ["dateString": dateString]
                    
                    DispatchQueueHandler.notification.queue.async {
                        NotificationCenter.default.post(name: Notifications.names.newEventCreated.name, object: nil, userInfo: createUserInfo)
                    }
                    
                    //Tell calendar view to remove events for the date and then reload them.
                    let deleteUserInfo = ["EventDisplayViewId": "none", "dateString": oldDate]
                    DispatchQueueHandler.notification.queue.async {
                        NotificationCenter.default.post(name: Notifications.names.eventDeleted.name, object: nil, userInfo: deleteUserInfo as! [String: String])
                    }
                    
                } else {
                    //Create new event for existing person
                    let eb = EventBuilder.newEvent(with: DataPersistenceService.shared)
                    
                    if tempEventId != nil {
                        eb.changeUUID(tempEventId!)
                    }

                    eb.addType(self.eventType!)
                    eb.addDate(self.eventDate!)
                    
                    eb.addBudget(self.budgetView.getBudgetAmount())
                    eb.setToPerson(self.person!)
                    eb.canReturnEvent(completion: { (success, error) in
                        if error != nil {
                            self.createAlertForError(error!)
                        }
                    })
                    let event = eb.buildAndReturnEvent()
                    
                    if let gifts = self.addGiftView.getGifts() {
                        for g in gifts {
                            g.eventId = event.id
                        }
                    }
                    
                    //send notification
                    guard let dateString = event.dateString else { return }
                    let userInfo = ["dateString": dateString, "personId": event.person?.id!, "createEventState": self.createEventState?.rawValue]
                    
                    DispatchQueueHandler.notification.queue.async {
                        NotificationCenter.default.post(name: Notifications.names.newEventCreated.name, object: nil, userInfo: userInfo as! [String : String])
                    }
                    
                    //pass event to delegate
                    if self.delegate != nil {
                        self.delegate?.eventAddedToPerson(uuid: (event.id)!)
                    }
                }
                EventBuilder.save(with: DataPersistenceService.shared)
                self.navigationController?.popViewController(animated: true)
                
            } else if error != nil {
                createAlertForError(error!)
            }
        })
    }
}

//MARK: AutoCompleteTextFieldDelegate
extension CreateEventViewController: AutoCompleteTextFieldDelegate {
    
    func provideDatasource() {
        //provide complete list of person names
        guard let allPeople = PersonFRC.frc(byGroup: false)?.fetchedObjects else { return }
        var nameArray = [String]()
        for person in allPeople {
            nameArray.append(person.fullName!)
        }
        autoCompletePerson?.autoCompleteTF.datasource = nameArray
    }
    
    
    func returned(with selection: String) {
        print("SELECTED: \(selection)")
        self.person = PersonFRC.person(with: selection)
        if self.person != nil {
            autoCompletePerson?.updateImage(with: person!.profileImage)
        }
    }
    
    func textFieldCleared() {
        autoCompletePerson?.resetProfileImage()
        person = nil
    }
    
}

//MARK: SelectGiftViewDelegate
extension CreateEventViewController : SelectGiftVCDelegate {
    
    func selectedGift(_ gift: Gift) {
        if let currEvent = self.eventToBeEdited {
            gift.eventId = currEvent.id
        } else {
            tempEventId = UUID().uuidString
            gift.eventId = tempEventId
        }
        self.addGiftView.addGiftToList(gift)
    }
}

//MARK: BudgetViewDelegate
extension CreateEventViewController : BudgetViewDelegate {
    
    func sliderChangedValue() {
        self.editsMade = true
    }
}

