//
//  actionsButtonsView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-16.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

enum ActionsSelectionState: String {
    case unselected = "unselected"
    case selected = "selected"
    case completed = "completed"
}

enum ActionsSelectionType {
    case selectDeselect
    case checkList
}

protocol ActionsButtonsViewDelegate {
    func giftChangedTo(selectionState: ActionsSelectionState)
    func cardChangedTo(selectionState: ActionsSelectionState)
    func phoneChangedTo(selectionState: ActionsSelectionState)
}

class ActionsButtonsView: UIView {

    var delegate: ActionsButtonsViewDelegate?
    
    var addGiftImageControl: CustomImageControl!
    var addCardImageControl: CustomImageControl!
    var addPhoneImageControl: CustomImageControl!
    
    var tintUnselected = Theme.colors.lightToneOne.color
    var tintSelected = UIColor.white
    var tintCompleted = Theme.colors.yellow.color
    
    var actionsSelectionType: ActionsSelectionType = ActionsSelectionType.checkList
    var imageSize: CGFloat = 45
    
    convenience init(imageSize: CGFloat?, actionsSelectionType: ActionsSelectionType) {
        self.init(frame: .zero)
    
        if let size = imageSize {
            self.imageSize = size
        }
        self.actionsSelectionType = actionsSelectionType
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        
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
            imageControl.actionsSelectionState = ActionsSelectionState.unselected
            
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
    
    private func configure(imageControl: CustomImageControl, for selectionState: ActionsSelectionState) {
        
        imageControl.actionsSelectionState = selectionState
        if selectionState == ActionsSelectionState.completed {
            imageControl.imageView.tintColor = self.tintCompleted
        } else if selectionState == ActionsSelectionState.selected {
            imageControl.imageView.tintColor = tintSelected
        } else if selectionState == ActionsSelectionState.unselected {
            imageControl.imageView.tintColor = tintUnselected
        }

    }
    
    private func handleTouchesFor(imageControl: CustomImageControl) {
        if self.actionsSelectionType == ActionsSelectionType.checkList {
            if imageControl.actionsSelectionState == ActionsSelectionState.completed {
                //go back to selected/uncompleted
                configure(imageControl: imageControl, for: ActionsSelectionState.selected)
            } else if imageControl.actionsSelectionState == ActionsSelectionState.selected {
                //go to completed
                configure(imageControl: imageControl, for: ActionsSelectionState.completed)
            } else if imageControl.actionsSelectionState == ActionsSelectionState.unselected {
                //go to selected
                configure(imageControl: imageControl, for: ActionsSelectionState.selected)
            }
        } else {
            //setup for select/Deselect
            if imageControl.actionsSelectionState == ActionsSelectionState.selected {
                //go to unselected
                configure(imageControl: imageControl, for: ActionsSelectionState.unselected)
            } else if imageControl.actionsSelectionState == ActionsSelectionState.unselected {
                //go to selected
                configure(imageControl: imageControl, for: ActionsSelectionState.selected)
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
    
    func getSelectionState(for string: String) -> ActionsSelectionState {
        switch string {
        case ActionsSelectionState.unselected.rawValue: return .unselected
        case ActionsSelectionState.selected.rawValue: return .selected
        case ActionsSelectionState.completed.rawValue: return .completed
        default: return .unselected
        }
    }
    
    //MARK: Handle imageControl touched
    func addGiftTouched() {
        handleTouchesFor(imageControl: addGiftImageControl)
        if self.delegate != nil {
            delegate?.giftChangedTo(selectionState: addGiftImageControl.actionsSelectionState)
        }
    }
    
    func addCardTouched() {
        handleTouchesFor(imageControl: addCardImageControl)
        if self.delegate != nil {
            delegate?.cardChangedTo(selectionState: addCardImageControl.actionsSelectionState)
        }
    }
    
    func addPhoneTouched() {
        handleTouchesFor(imageControl: addPhoneImageControl)
        if self.delegate != nil {
            delegate?.phoneChangedTo(selectionState: addPhoneImageControl.actionsSelectionState)
        }
    }
}
