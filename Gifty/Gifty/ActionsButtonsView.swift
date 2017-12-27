//
//  actionsButtonsView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-16.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

struct ActionButton {
    
    enum SelectionStates: String {
        case unselected = "unselected"
        case selected = "selected"
        case completed = "completed"
    }

    enum SelectionTypes {
        case selectDeselect
        case checkList
    }

    enum Actions {
        case gift
        case card
        case phone
    }
}

protocol ActionsButtonsViewDelegate {
    func setAction(_ action: ActionButton.Actions, to state: ActionButton.SelectionStates)
    func budgetButtonTouched()
}

class ActionsButtonsView: UIView {

    var delegate: ActionsButtonsViewDelegate?
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    var budgetImageControl: CustomImageControl?
    
    var tintUnselected = Theme.colors.lightToneOne.color
    var tintSelected = Theme.colors.lightToneTwo.color
    var tintCompleted = Theme.colors.completedGreen.color
    
    var actionsSelectionType: ActionButton.SelectionTypes = ActionButton.SelectionTypes.checkList
    var imageSize: CGFloat = 45
    
    convenience init(imageSize: CGFloat?, actionsSelectionType: ActionButton.SelectionTypes) {
        self.init(frame: .zero)
    
        if let size = imageSize {
            self.imageSize = size
        }
        self.actionsSelectionType = actionsSelectionType
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        
        var imageNames: [ImageNames] = [ImageNames.addGift, ImageNames.addGreetingCard, ImageNames.addPhoneCall]
        if self.actionsSelectionType == .checkList {
            imageNames.insert(ImageNames.budget, at: 0)
        }
        
        for name in imageNames {
            
            let imageControl = CustomImageControl()
            imageControl.translatesAutoresizingMaskIntoConstraints = false
            imageControl.imageView.image = UIImage(named: name.rawValue)?.withRenderingMode(.alwaysTemplate)
            imageControl.imageView.contentMode = .scaleAspectFit
            imageControl.imageView.tintColor = Theme.colors.lightToneOne.color
            imageControl.actionsSelectionState = ActionButton.SelectionStates.unselected
            
            imageControl.heightAnchor.constraint(equalToConstant: self.imageSize).isActive = true
            imageControl.widthAnchor.constraint(equalToConstant: self.imageSize).isActive = true
            
            switch name {
            case .addGift:
                addGiftImageControl = imageControl
                stackView.addArrangedSubview(addGiftImageControl)
            case .addGreetingCard:
                addCardImageControl = imageControl
                stackView.addArrangedSubview(addCardImageControl)
            case .addPhoneCall:
                addPhoneImageControl = imageControl
                stackView.addArrangedSubview(addPhoneImageControl)
            case .budget:
                budgetImageControl = imageControl
                budgetImageControl?.imageView.tintColor = Theme.colors.yellow.color
                stackView.addArrangedSubview(budgetImageControl!)
            default:
                print("error setting up stackview")
            }

            addSubview(stackView)
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        if self.budgetImageControl != nil {
            self.budgetImageControl?.addTarget(self, action: #selector(budgetButtonTouched(sender:)), for: .touchUpInside)
        }
        addGiftImageControl.addTarget(self, action: #selector(addGiftTouched), for: .touchUpInside)
        addCardImageControl.addTarget(self, action: #selector(addCardTouched), for: .touchUpInside)
        addPhoneImageControl.addTarget(self, action: #selector(addPhoneTouched), for: .touchUpInside)
    }
    
    private func configure(imageControl: CustomImageControl, for selectionState: ActionButton.SelectionStates) {
        
        imageControl.actionsSelectionState = selectionState
        if selectionState == ActionButton.SelectionStates.completed && actionsSelectionType == .checkList {
            imageControl.imageView.tintColor = self.tintCompleted
        } else if selectionState == ActionButton.SelectionStates.completed && actionsSelectionType == .selectDeselect {
            imageControl.imageView.tintColor = tintSelected
        } else if selectionState == ActionButton.SelectionStates.selected {
            imageControl.imageView.tintColor = tintSelected
        } else if selectionState == ActionButton.SelectionStates.unselected {
            imageControl.imageView.tintColor = tintUnselected
        }
    }
    
    private func handleTouchesFor(imageControl: CustomImageControl) {
        if self.actionsSelectionType == ActionButton.SelectionTypes.checkList {
            if imageControl.actionsSelectionState == ActionButton.SelectionStates.completed {
                //go back to selected/uncompleted
                configure(imageControl: imageControl, for: ActionButton.SelectionStates.selected)
            } else if imageControl.actionsSelectionState == ActionButton.SelectionStates.selected {
                //go to completed
                configure(imageControl: imageControl, for: ActionButton.SelectionStates.completed)
            } else if imageControl.actionsSelectionState == ActionButton.SelectionStates.unselected {
                //go to selected
                //configure(imageControl: imageControl, for: ActionSelectionStates.selected)
            }
        } else {
            //setup for select/Deselect
            if imageControl.actionsSelectionState == ActionButton.SelectionStates.selected {
                //go to unselected
                configure(imageControl: imageControl, for: ActionButton.SelectionStates.unselected)
            } else if imageControl.actionsSelectionState == ActionButton.SelectionStates.unselected {
                //go to selected
                configure(imageControl: imageControl, for: ActionButton.SelectionStates.selected)
            }
        }
    }
    
    func configureButtonStatesFor(event: Event) {
        
        setupSubviews()
        
        guard event.giftState != nil, event.cardState != nil, event.phoneState != nil else { return }
        
        configure(imageControl: addGiftImageControl, for: getSelectionState(for: event.giftState!))
        configure(imageControl: addCardImageControl, for: getSelectionState(for: event.cardState!))
        configure(imageControl: addPhoneImageControl, for: getSelectionState(for: event.phoneState!))
    }
    
    func getSelectionState(for string: String) -> ActionButton.SelectionStates {
        switch string {
        case ActionButton.SelectionStates.unselected.rawValue: return .unselected
        case ActionButton.SelectionStates.selected.rawValue: return .selected
        case ActionButton.SelectionStates.completed.rawValue: return .completed
        default: return .unselected
        }
    }
    
    //MARK: Handle imageControl touched
    @objc private func addGiftTouched(sender: CustomImageControl) {
        if shouldUpdate(imageControl: addGiftImageControl) {
            handleTouchesFor(imageControl: addGiftImageControl)
            if self.delegate != nil {
                delegate?.setAction(ActionButton.Actions.gift, to: addGiftImageControl.actionsSelectionState)
            }
            addGiftImageControl.bounceAnimation()
        }
    }
    
    @objc private func addCardTouched(sender: CustomImageControl) {
        if shouldUpdate(imageControl: addCardImageControl) {
            handleTouchesFor(imageControl: addCardImageControl)
            
            self.delegate?.setAction(ActionButton.Actions.card, to: addCardImageControl.actionsSelectionState)
            
            addCardImageControl.bounceAnimation()
        }
    }
    
    @objc private func addPhoneTouched(sender: CustomImageControl) {
        if shouldUpdate(imageControl: addPhoneImageControl) {
            handleTouchesFor(imageControl: addPhoneImageControl)
            
            self.delegate?.setAction(ActionButton.Actions.phone, to: addPhoneImageControl.actionsSelectionState)
            
            addPhoneImageControl.bounceAnimation()
        }
    }
    
    private func shouldUpdate(imageControl: CustomImageControl) -> Bool {
        if self.actionsSelectionType == .checkList && imageControl.actionsSelectionState == .unselected {
            return false
        } else {
            return true
        }
    }
    
    @objc private func budgetButtonTouched(sender: CustomImageControl) {
        print("budget button touched")
        
        self.delegate?.budgetButtonTouched()
    }
}
