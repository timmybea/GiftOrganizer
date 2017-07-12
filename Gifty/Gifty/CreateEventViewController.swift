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
            print("update event type to \(eventType)")
        }
    }
    
    var eventDate: Date? = Date()
    
    var addGift: Bool = false
    var addCard: Bool = false
    var addPhone: Bool = false
    
    var dropDown: DropDownTextField!
    
    var addDate: AddDateView!
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    
    var autoCompletePerson: AutoCompletePerson!
    
    var budgetView: BudgetView!
    
    var saveButton: ButtonTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Event"
        if let state = self.createEventState {
            layoutSubviews(for: state)
        }
    }
    
    
    func layoutSubviews(for createEventState: CreateEventState) {
        
        if createEventState == CreateEventState.newEventForPerson || createEventState == CreateEventState.updateEventForPerson {
            
            basicSubviewLayout()
            
        } else if self.createEventState == CreateEventState.newEventToBeAssigned {
            
//            let autoFrame = CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 50)
//            autoCompletePerson = AutoCompletePerson(frame: autoFrame)
//            view.addSubview(autoCompletePerson)
//            
//            guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
//            
//            let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
//            saveButton = ButtonTemplate(frame: buttonframe, title: "SAVE")
//            saveButton.addTarget(self, action: #selector(addEventToPersonTouched), for: .touchUpInside)
//            view.addSubview(saveButton)
            
        }
    }
    
    func basicSubviewLayout() {
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        
        var currMaxY: CGFloat = 0
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            currMaxY = navHeight + UIApplication.shared.statusBarFrame.height + pad
            let frame = CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 40)
            let options = ["Birthday", "Graduation", "Wedding", "Baby Shower"]
            dropDown = DropDownTextField(frame: frame, title: "Celebration Type", options: options)
            dropDown.delegate = self
            view.addSubview(dropDown)
        }
        
        currMaxY += 40 + pad
        addDate = AddDateView(frame: CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 25))
        addDate.delegate = self
        view.addSubview(addDate)
        
        currMaxY += addDate.frame.height + pad
        
        let actions = UILabel(frame: CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 20))
        actions.textColor = UIColor.white
        actions.font = FontManager.subtitleText
        actions.text = "Actions:"
        view.addSubview(actions)
        
        currMaxY += actions.frame.height + pad
        let oneFourthViewWidth = view.bounds.width / 4
        let size: CGFloat = 45
        
        addGiftImageControl = CustomImageControl(frame: CGRect(x: oneFourthViewWidth - (size / 2), y: currMaxY, width: size, height: size))
        addGiftImageControl.imageView.image = UIImage(named: ImageNames.addGift.rawValue)?.withRenderingMode(.alwaysTemplate)
        addGiftImageControl.imageView.contentMode = .scaleAspectFit
        addGiftImageControl.imageView.tintColor = ColorManager.lightText
        view.addSubview(addGiftImageControl)
        
        addCardImageControl = CustomImageControl(frame: CGRect(x: (2 * oneFourthViewWidth) - (size / 2), y: currMaxY, width: size, height: size))
        addCardImageControl.imageView.image = UIImage(named: ImageNames.addGreetingCard.rawValue)?.withRenderingMode(.alwaysTemplate)
        addCardImageControl.imageView.contentMode = .scaleAspectFit
        addCardImageControl.tintColor = ColorManager.lightText
        view.addSubview(addCardImageControl)
        
        addPhoneImageControl = CustomImageControl(frame: CGRect(x: (3 * oneFourthViewWidth) - (size / 2), y: currMaxY, width: size, height: size))
        addPhoneImageControl.imageView.image = UIImage(named: ImageNames.addPhoneCall.rawValue)?.withRenderingMode(.alwaysTemplate)
        addPhoneImageControl.imageView.contentMode = .scaleAspectFit
        addPhoneImageControl.tintColor = ColorManager.lightText
        view.addSubview(addPhoneImageControl)
        
        addGiftImageControl.addTarget(self, action: #selector(addGiftTouched), for: .touchUpInside)
        addCardImageControl.addTarget(self, action: #selector(addCardTouched), for: .touchUpInside)
        addPhoneImageControl.addTarget(self, action: #selector(addPhoneTouched), for: .touchUpInside)
        
        currMaxY += addCardImageControl.frame.height + pad
        budgetView = BudgetView(frame: CGRect(x: pad, y: currMaxY, width: view.bounds.width - pad - pad, height: 20))
        view.addSubview(budgetView)
        
        currMaxY += budgetView.frame.height + pad
    }
    
    func didTapBackground() {
        dropDown.finishEditingTextField()
        
    }
}


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
    }
}

extension CreateEventViewController {
    
    func addGiftTouched() {
        addGiftImageControl.imageView.tintColor = addGiftImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addGiftImageControl.isImageSelected = !addGiftImageControl.isImageSelected
    }
    
    func addCardTouched() {
        addCardImageControl.imageView.tintColor = addCardImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addCardImageControl.isImageSelected = !addCardImageControl.isImageSelected
    
    }
    
    func addPhoneTouched() {
        addPhoneImageControl.imageView.tintColor = addPhoneImageControl.isImageSelected ? ColorManager.lightText : UIColor.white
        addPhoneImageControl.isImageSelected = !addPhoneImageControl.isImageSelected
    }
}

extension CreateEventViewController: AddDateViewDelegate {
    
    func addDateViewWasTouched() {
        print("select date vc")
    }
}

//MARK: ADD EVENT TO PERSON
extension CreateEventViewController {
    
    func addEventToPersonTouched() {
        
        if self.createEventState == CreateEventState.newEventForPerson {
            //Create New Event For Person
            checkSufficientInformationToCreateEvent()
            
            ManagedObjectBuilder.addNewEventToPerson(date: Date(), type: "graduation", gift: true, card: true, phone: false, person: self.person!) { (success, event) in
                
                print("successfully added event")
                
                if self.delegate != nil {
                    self.delegate?.eventAddedToPerson()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        //update existing event for person
        
        
        
        //create new event and assign to person
        
    }
    
    func checkSufficientInformationToCreateEvent() {
        
        
        
        
    }
}
