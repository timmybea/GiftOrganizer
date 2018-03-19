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
    
    var delegate: CreateEventViewControllerDelegate?
    
    var person: Person? {
        didSet {
            print("CreateEvent: Person assigned to \(String(describing: person?.fullName!))")
        }
    }
    
    private var eventType: String? {
        didSet {
            print("update event type to \(String(describing: eventType))")
        }
    }
    
    private var eventDate: Date? {
        didSet {
            print("event date changed to \(String(describing: eventDate))")
            addDateView.updateLabel(with: eventDate)
        }
    }
    
    private var isRecurringEvent = false {
        didSet {
            addDateView.recurringEventSwitch.setOn(isRecurringEvent, animated: true)
        }
    }
    
    private var addGift = ActionButton.SelectionStates.unselected
    private var addCard = ActionButton.SelectionStates.unselected
    private var addPhone = ActionButton.SelectionStates.unselected
    
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
    
    lazy var actionsButtonsView: ActionsButtonsView = {
        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionButton.SelectionTypes.selectDeselect)
        view.tintUnselected = Theme.colors.lightToneOne.color
        view.tintSelected = UIColor.white
        view.delegate = self
        return view
    }()
    
    var autoCompletePerson: AutoCompletePerson?
    
    private var budgetView: BudgetView!
    
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
        saveButton.addTarget(self, action: #selector(addEventToPersonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
        
        //scrollView
        scrollViewFrame = CGRect(x: pad,
                                 y: navHeight + statusHeight + pad,
                                 width: view.bounds.width - pad - pad,
                                 height: view.bounds.height - navHeight - statusHeight - pad - tabBarHeight - pad - 35)
        
        scrollView.frame = scrollViewFrame
        view.addSubview(scrollView)
        
        //dropDown
        let dropDownFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: 40)
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Celebration Type", options: SettingsHandler.shared.celebrations)
        dropDown.delegate = self
        scrollView.addSubview(dropDown)

        //addDateView
        addDateView = AddDateView(frame: CGRect(x: 0,
                                                y: 50 + pad,
                                                width: scrollView.bounds.width,
                                                height: 25))
        addDateView.delegate = self
        scrollView.addSubview(addDateView)

        //actionsLabel
        let actionsLabel = Theme.createMediumLabel()
        actionsLabel.frame = CGRect(x: 0,
                                    y: addDateView.frame.maxY + pad,
                                    width: scrollView.bounds.width,
                                    height: 25)
        actionsLabel.text = "Select Actions"
        scrollView.addSubview(actionsLabel)

        //actionsButtonsView
        actionsButtonsView.frame = CGRect(x: 30,
                                          y: actionsLabel.frame.maxY + pad,
                                          width: self.scrollView.bounds.width - 60,
                                          height: actionsButtonsView.imageSize)
        scrollView.addSubview(actionsButtonsView)
        actionsButtonsView.setupSubviews()
        
        //budgetLabel
        let budgetLabel = Theme.createMediumLabel()
        budgetLabel.frame = CGRect(x: 0,
                                   y: actionsButtonsView.frame.maxY + pad,
                                   width: scrollView.bounds.width,
                                   height: 25)
        budgetLabel.text = "Set Budget"
        scrollView.addSubview(budgetLabel)

        //budgetView
        budgetView = BudgetView(frame: CGRect(x: 0,
                                              y: budgetLabel.frame.maxY + pad,
                                              width: scrollView.bounds.width,
                                              height: 60))
        scrollView.addSubview(budgetView)

        var contentHeight = budgetView.frame.maxY + pad
        
        if createEventState == .updateEventForPerson {
            setupEventDataForEdit()
        } else if createEventState == .newEventToBeAssigned {
            //autoCompletePerson
            let personLabel = Theme.createMediumLabel()
            personLabel.frame = CGRect(x: 0,
                                       y: budgetView.frame.maxY + pad,
                                       width: scrollView.bounds.width,
                                       height: 25)
            personLabel.text = "Set Person"
            scrollView.addSubview(personLabel)
            
            autoCompletePerson = AutoCompletePerson(frame: CGRect(x: 0,
                                                                  y: personLabel.frame.maxY + pad,
                                                                  width: scrollView.bounds.width,
                                                                  height: 100))
            self.autoCompletePerson?.autoCompleteTF.autocompleteDelegate = self
            scrollView.addSubview(autoCompletePerson!)
            contentHeight = autoCompletePerson!.frame.maxY + pad
        }
        //set content size for scrollView
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentHeight)
    }
    
    private func setupEventDataForEdit() {
        
        guard let currentEvent = self.eventToBeEdited else {
            print("No event to update")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.navigationItem.title = "Event for \(currentEvent.person!.firstName!)"
        
        self.dropDown.setTitle(text: currentEvent.type!)
        self.eventType = currentEvent.type!
        
        self.eventDate = currentEvent.date!
        
        self.isRecurringEvent = true //<<<<PULL THIS OUT OF EVENT
        
        actionsButtonsView.configureButtonStatesFor(event: currentEvent)
        self.addGift = getActionState(for: currentEvent.giftState!)
        self.addCard = getActionState(for: currentEvent.cardState!)
        self.addPhone = getActionState(for: currentEvent.phoneState!)
        
        budgetView.setTo(amount: currentEvent.budgetAmt)
        
        self.saveButton.setTitle("UPDATE EVENT")
    }
    
    private func getActionState(for action: String) -> ActionButton.SelectionStates {
        switch action {
        case ActionButton.SelectionStates.unselected.rawValue:
            return ActionButton.SelectionStates.unselected
        case ActionButton.SelectionStates.selected.rawValue:
            return ActionButton.SelectionStates.selected
        case ActionButton.SelectionStates.completed.rawValue:
            return ActionButton.SelectionStates.completed
        default:
            return ActionButton.SelectionStates.unselected
        }
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
        if changesMade() {
            let alert = UIAlertController(title: "Are you sure?", message: CustomErrors.createEvent.changesMade.description, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
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

//MARK: ActionsButtonsViewDelegate Methods
extension CreateEventViewController: ActionsButtonsViewDelegate {
    
    func budgetButtonTouched() {
        //do nothing
    }

    func setAction(_ action: ActionButton.Actions, to state: ActionButton.SelectionStates) {
        
        if action == ActionButton.Actions.gift {
            self.addGift = state
            print("Event gift state: \(self.addGift.rawValue)")
        } else if action == ActionButton.Actions.card {
            self.addCard = state
            print("Event card state: \(self.addCard.rawValue)")
        } else if action == ActionButton.Actions.phone {
            self.addPhone = state
            print("Event phone state: \(self.addPhone.rawValue)")
        }
    }
}


//MARK: AddEventButton Method
extension CreateEventViewController {
    
    @objc func addEventToPersonTouched() {
        
        if self.createEventState == CreateEventState.updateEventForPerson {
            //update existing event and save
            guard let currEvent = self.eventToBeEdited else { return }
            checkSufficientInformationToCreateEvent(completion: { (success, error) in
                if success {
                    
                    let oldDate = currEvent.dateString
                    
                    currEvent.type = self.eventType
                    currEvent.date = self.eventDate
                    currEvent.dateString = DateHandler.stringFromDate(self.eventDate!)
                    currEvent.budgetAmt = self.budgetView.getBudgetAmount()
                    currEvent.giftState = self.addGift.rawValue
                    EventFRC.updateMoc()
                    
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
                    
                } else if error != nil {
                    createAlertForError(error!)
                }
            })
            self.navigationController?.popViewController(animated: true)
        } else {
        
            //Create new event for existing person
            checkSufficientInformationToCreateEvent(completion: { (success, error) in
                if success {
                    let budgetAmt = self.budgetView.getBudgetAmount()
                    ManagedObjectBuilder.addNewEventToPerson(date: eventDate!, type: eventType!, gift: addGift, card: addCard, phone: addPhone, person: person!, budgetAmt: budgetAmt) { (success, event) in
                        
                        print("successfully added event")
                        //send notification
                        guard let dateString = event?.dateString else { return }
                        let userInfo = ["dateString": dateString, "personId": person?.id!, "createEventState": self.createEventState?.rawValue]
                    
                        DispatchQueueHandler.notification.queue.async {
                            NotificationCenter.default.post(name: Notifications.names.newEventCreated.name, object: nil, userInfo: userInfo as! [String : String])
                        }
                        
                        if self.delegate != nil {
                            self.delegate?.eventAddedToPerson(uuid: (event?.id)!)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if error != nil {
                        createAlertForError(error!)
                    }
                }
            })
            if createEventState == CreateEventState.newEventToBeAssigned {
                EventFRC.updateMoc()
            }
        }
    }
    
    private func checkSufficientInformationToCreateEvent(completion: (_ success: Bool, _ error: CustomErrors.createEvent?) -> Void) {
        
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
    
    private func changesMade() -> Bool {
        guard self.eventType == nil else { return true }
        guard self.eventDate == nil else { return true }
        guard self.person == nil else { return true }
        guard self.budgetView.getBudgetAmount() == 0 else { return true }
        return false
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

