//
//  CreateEventViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol CreateEventViewControllerDelegate {
    func eventAddedToPerson(uuid: String)
}

enum CreateEventState {
    case newEventForPerson
    case updateEventForPerson
    case newEventToBeAssigned
}

class CreateEventViewController: CustomViewController {
    
    var createEventState: CreateEventState?

    var delegate: CreateEventViewControllerDelegate?
    
    var person: Person? {
        didSet {
            print("CreateEvent: Person assigned to \(String(describing: person?.fullName!))")
        }
    }
    
    var eventType: String? {
        didSet {
            print("update event type to \(String(describing: eventType))")
        }
    }
    
    var eventDate: Date? {
        didSet {
            print("event date changed to \(String(describing: eventDate))")
            addDateView.updateLabel(with: eventDate)
        }
    }
    var isRecurringEvent = false
    var addGift = ActionButton.SelectionStates.unselected
    var addCard = ActionButton.SelectionStates.unselected
    var addPhone = ActionButton.SelectionStates.unselected
    
    var dropDown: DropDownTextField!
    
    var addDateView: AddDateView!
    
    
    lazy var actionsButtonsView: ActionsButtonsView = {
        let view = ActionsButtonsView(imageSize: 34, actionsSelectionType: ActionButton.SelectionTypes.selectDeselect)
        view.tintUnselected = Theme.colors.lightToneOne.color
        view.tintSelected = UIColor.white
        view.delegate = self
        return view
    }()
    
    var autoCompletePerson: AutoCompletePerson!
    
    var budgetView: BudgetView!
    
    var saveButton: ButtonTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Event"
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue), style: .plain, target: self, action: #selector(backButtonTouched))
        self.navigationItem.leftBarButtonItem = backButton
        
        if let state = self.createEventState {
            layoutSubviews(for: state)
        }
    }
    
    //MARK: LAYOUT SUBVIEWS
    func layoutSubviews(for createEventState: CreateEventState) {
        
        if createEventState == CreateEventState.newEventForPerson || createEventState == CreateEventState.updateEventForPerson {
            
            basicSubviewLayout()
            
        } else if self.createEventState == CreateEventState.newEventToBeAssigned {
            

            
        }
    }
    
    func basicSubviewLayout() {
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground(sender:))))
        
        var yVal: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            yVal = navHeight + UIApplication.shared.statusBarFrame.height + pad
            let frame = CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 40)
            dropDown = DropDownTextField(frame: frame, title: "Celebration Type", options: SettingsHandler.shared.celebrations)
            dropDown.delegate = self
            view.addSubview(dropDown)
        }
        
        yVal += 40 + pad + pad
        addDateView = AddDateView(frame: CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 25))
        addDateView.delegate = self
        view.addSubview(addDateView)
        
        yVal += addDateView.frame.height + pad
        
        let actionsLabel = Theme.createMediumLabel()
        actionsLabel.frame = CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 25)
        actionsLabel.text = "Select Actions"
        view.addSubview(actionsLabel)

        yVal += actionsLabel.frame.height + smallPad
        
        actionsButtonsView.frame = CGRect(x: self.view.frame.width / 4, y: yVal, width: self.view.frame.width / 2, height: actionsButtonsView.imageSize)
        view.addSubview(actionsButtonsView)
        actionsButtonsView.setupSubviews()
        
        //budget view layout
        yVal += actionsButtonsView.frame.height + pad
        
        let budgetLabel = Theme.createMediumLabel()
        budgetLabel.frame = CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 25)
        budgetLabel.text = "Set Budget"
        view.addSubview(budgetLabel)
        
        yVal += budgetLabel.frame.height + smallPad
        
        self.budgetView = BudgetView(frame: CGRect(x: pad, y: yVal, width: self.view.frame.width - pad - pad, height: 60))
        view.addSubview(budgetView)

        //save button layout
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
        saveButton = ButtonTemplate(frame: buttonframe)
        saveButton.setTitle("ADD EVENT")
        saveButton.addBorder(with: UIColor.white)
        saveButton.addTarget(self, action: #selector(addEventToPersonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @objc func didTapBackground(sender: UITapGestureRecognizer) {
        dropDown.finishEditingTextField()
    }
    
    private func createAlertForError(_ error: CustomErrors.createEvent) {
        
        let alertController = UIAlertController(title: "Incomplete event", message: error.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK: Drop down textfield delegate

extension CreateEventViewController: DropDownTextFieldDelegate {
    
    func dropDownWillAnimate(down: Bool) {
        if down {
            view.bringSubview(toFront: dropDown)
        } else {
            view.insertSubview(dropDown, aboveSubview: backgroundView)
        }
    }
    
    func optionSelected(option: String) {
        self.eventType = option
        print("event selected: \(String(describing: self.eventType))")
    }
}

extension CreateEventViewController {
    
    @objc func backButtonTouched() {
        
        //check if there are changes and send alert
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: ADD_DATE_VIEW DELEGATE
extension CreateEventViewController: AddDateViewDelegate {
    
    func addDateViewWasTouched() {

        let destination = DatePickerViewController()
        destination.delegate = self
        if self.eventDate != nil {
            destination.initialDate = self.eventDate
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

//MARK: DATE_PICKER_VC DELEGATE
extension CreateEventViewController: datePickerViewControllerDelegate {
    
    func didSetDate(_ date: Date?) {
        self.eventDate = date
    }
    
}

//MARK: ACTIONS_SELECTOR_DELEGATE METHODS
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

//MARK: ADD EVENT BUTTON
extension CreateEventViewController {
    
    @objc func addEventToPersonTouched() {
        
        if self.createEventState == CreateEventState.newEventForPerson {
            //Create New Event For Person

            checkSufficientInformationToCreateEvent(completion: { (success, error) in
                
                if success {
                    
                    let budgetAmt = self.budgetView.getBudgetAmount()
                    
                    ManagedObjectBuilder.addNewEventToPerson(date: eventDate!, type: eventType!, gift: addGift, card: addCard, phone: addPhone, person: person!, budgetAmt: budgetAmt) { (success, event) in
                        
                        print("successfully added event")
                        
                        //send notification
                        guard let dateString = event?.dateString else { return }
                        let userInfo = ["dateString": dateString]
                        NotificationCenter.default.post(name: Notifications.names.newEventCreated.name, object: nil, userInfo: userInfo)
                        
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
        }
        
        
        //update existing event for person
        
        
        
        //create new event and assign to person
        
    }
    
    func checkSufficientInformationToCreateEvent(completion: (_ success: Bool, _ error: CustomErrors.createEvent?) -> Void) {
        
        guard self.eventType != nil else {
            completion(false, CustomErrors.createEvent.noEventType)
            return
        }
        
        guard self.eventDate != nil else {
            completion(false, CustomErrors.createEvent.noDate)
            return
        }
        
        guard self.person != nil else {
            completion(false, CustomErrors.createEvent.personIsNil)
            return
        }
        
        completion(true, nil)
    }
}
