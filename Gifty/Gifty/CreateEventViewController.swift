//
//  CreateEventViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol CreateEventViewControllerDelegate {
    func eventAddedToPerson()
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
    var addGift: Bool = false
    var addCard: Bool = false
    var addPhone: Bool = false
    
    var dropDown: DropDownTextField!
    
    var addDateView: AddDateView!
    
    var actionsSelectorView: ActionsSelectorView!
    
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
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        
        var yVal: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            yVal = navHeight + UIApplication.shared.statusBarFrame.height + pad
            let frame = CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 40)
            let options = ["Birthday", "Graduation", "Wedding", "Baby Shower"]
            dropDown = DropDownTextField(frame: frame, title: "Celebration Type", options: options)
            dropDown.delegate = self
            view.addSubview(dropDown)
        }
        
        yVal += 40 + pad + pad
        addDateView = AddDateView(frame: CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 25))
        addDateView.delegate = self
        view.addSubview(addDateView)
        
        yVal += addDateView.frame.height + pad + pad
        
        actionsSelectorView = ActionsSelectorView(frame: CGRect(x: 0, y: yVal, width: view.bounds.width, height: 85))
        actionsSelectorView.delegate = self
        view.addSubview(actionsSelectorView)
        
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
        saveButton = ButtonTemplate(frame: buttonframe, title: "ADD EVENT")
        saveButton.addTarget(self, action: #selector(addEventToPersonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    func didTapBackground() {
        dropDown.finishEditingTextField()
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
    
    func backButtonTouched() {
        
        //check if there are changes and send alert
        self.navigationController?.popViewController(animated: true)
    }
}




//MARK: ADD DATE VIEW DELEGATE
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

//MARK: DATE PICKER VC DELEGATE
extension CreateEventViewController: datePickerViewControllerDelegate {
    
    func didSetDate(_ date: Date?) {
        self.eventDate = date
    }
    
}

//MARK: ACTIONS SELECTOR DELEGATE METHODS
extension CreateEventViewController: ActionsSelectorViewDelegate {
    
    func addGiftChanged(bool: Bool) {
        addGift = bool
        print("add gift: \(addGift)")
    }
    
    func addCardChanged(bool: Bool) {
        addCard = bool
        print("add card: \(addCard)")
    }
    
    func addPhoneChanged(bool: Bool) {
        addPhone = bool
        print("add phone: \(addPhone)")
    }
}

//MARK: ADD EVENT TO PERSON
extension CreateEventViewController {
    
    func addEventToPersonTouched() {
        
        if self.createEventState == CreateEventState.newEventForPerson {
            //Create New Event For Person

            checkSufficientInformationToCreateEvent(completion: { (success) in
                
                ManagedObjectBuilder.addNewEventToPerson(date: eventDate!, type: eventType!, gift: addGift, card: addCard, phone: addPhone, person: person!) { (success, event) in
                    
                    print("successfully added event")
                    
                    if self.delegate != nil {
                        self.delegate?.eventAddedToPerson()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
        }
        
        
        //update existing event for person
        
        
        
        //create new event and assign to person
        
    }
    
    func checkSufficientInformationToCreateEvent(completion: (_ success: Bool) -> Void) {
        
        guard self.eventDate != nil else {
            completion(false)
            return
        }
        
        guard self.eventType != nil else {
            completion(false)
            return
        }

        guard self.person != nil else {
            completion(false)
            return
        }
        
        completion(true)
    }
}
