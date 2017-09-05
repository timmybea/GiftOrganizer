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
}

class ActionsButtonsView: UIView {

    var delegate: ActionsButtonsViewDelegate?
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    
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
        
        let imageNames: [ImageNames] = [ImageNames.addGift, ImageNames.addGreetingCard, ImageNames.addPhoneCall]
        var imageControls = [CustomImageControl]()
        
        for (index, name) in imageNames.enumerated() {
            
            let imageControl = CustomImageControl()
            imageControl.translatesAutoresizingMaskIntoConstraints = false
            imageControl.imageView.image = UIImage(named: name.rawValue)?.withRenderingMode(.alwaysTemplate)
            imageControl.imageView.contentMode = .scaleAspectFit
            imageControl.imageView.tintColor = Theme.colors.lightToneOne.color
            imageControl.actionsSelectionState = ActionButton.SelectionStates.unselected
            
            self.addSubview(imageControl)
            imageControl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            imageControl.widthAnchor.constraint(equalToConstant: self.imageSize).isActive = true
            imageControl.heightAnchor.constraint(equalToConstant: self.imageSize).isActive = true
            
            if index == 0 {
                imageControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            } else if index == 1 {
                imageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            } else if index == 2 {
                imageControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }
        
            imageControls.append(imageControl)
        }
        
        self.addGiftImageControl = imageControls[0]
        self.addCardImageControl = imageControls[1]
        self.addPhoneImageControl = imageControls[2]
        
        addGiftImageControl.addTarget(self, action: #selector(addGiftTouched), for: .touchUpInside)
        addCardImageControl.addTarget(self, action: #selector(addCardTouched), for: .touchUpInside)
        addPhoneImageControl.addTarget(self, action: #selector(addPhoneTouched), for: .touchUpInside)
    }
    
    private func configure(imageControl: CustomImageControl, for selectionState: ActionButton.SelectionStates) {
        
        imageControl.actionsSelectionState = selectionState
        if selectionState == ActionButton.SelectionStates.completed {
            imageControl.imageView.tintColor = self.tintCompleted
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
    func addGiftTouched() {
        if shouldUpdate(imageControl: addGiftImageControl) {
            handleTouchesFor(imageControl: addGiftImageControl)
            if self.delegate != nil {
                delegate?.setAction(ActionButton.Actions.gift, to: addGiftImageControl.actionsSelectionState)
            }
            addGiftImageControl.bounceAnimation()
        }
    }
    
    func addCardTouched() {
        if shouldUpdate(imageControl: addCardImageControl) {
            handleTouchesFor(imageControl: addCardImageControl)
            if self.delegate != nil {
                delegate?.setAction(ActionButton.Actions.card, to: addCardImageControl.actionsSelectionState)
            }
            addCardImageControl.bounceAnimation()
        }
    }
    
    func addPhoneTouched() {
        if shouldUpdate(imageControl: addPhoneImageControl) {
            handleTouchesFor(imageControl: addPhoneImageControl)
            if self.delegate != nil {
                delegate?.setAction(ActionButton.Actions.phone, to: addPhoneImageControl.actionsSelectionState)
            }
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

}
