//
//  EventActivityView.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-23.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

enum ActivityType {
    case budgetActivity
    case giftActivity
    case reminderActivity
    case editActivity
}

protocol EventActivityViewDelegate {
    func activityButtonTouched(activity: ActivityType)
}

class EventActivityView : UIView {
    
    var delegate: EventActivityViewDelegate?
    
    var budgetControl: CustomImageControl?
    var giftControl: CustomImageControl?
    var remindersControl: CustomImageControl?
    var editControl: CustomImageControl?
    
    static var imageSize: CGFloat = 34
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupSubviews()
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
        
        let imageNames: [ImageNames] = [ImageNames.budget, ImageNames.addGift, ImageNames.reminderIcon, ImageNames.editIcon]
        for name in imageNames {
            let imageControl = CustomImageControl()
            imageControl.identifier = name.rawValue
            imageControl.addTarget(self, action: #selector(activityTouched(sender:)), for: .touchUpInside)
            imageControl.translatesAutoresizingMaskIntoConstraints = false
            imageControl.imageView.image = UIImage(named: name.rawValue)?.withRenderingMode(.alwaysTemplate)
            imageControl.imageView.contentMode = .scaleAspectFit
            imageControl.imageView.tintColor = Theme.colors.lightToneTwo.color
            
            NSLayoutConstraint.activate([
                imageControl.heightAnchor.constraint(equalToConstant: type(of: self).imageSize),
                imageControl.widthAnchor.constraint(equalToConstant: type(of: self).imageSize)
                ])
            
            switch name {
            case .budget:
                budgetControl = imageControl
                stackView.addArrangedSubview(budgetControl!)
            case .addGift:
                giftControl = imageControl
                stackView.addArrangedSubview(giftControl!)
            case .reminderIcon:
                remindersControl = imageControl
                stackView.addArrangedSubview(remindersControl!)
            case .editIcon:
                editControl = imageControl
                stackView.addArrangedSubview(editControl!)
            default:
                print("error setting up stackview")
            }
            
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }
    }
    
    @objc
    func activityTouched(sender: CustomImageControl) {
        
        guard let id = sender.identifier else { return }
        
        var activity: ActivityType = .budgetActivity
        
        switch id {
        case ImageNames.budget.rawValue: activity = .budgetActivity
        case ImageNames.addGift.rawValue: activity = .giftActivity
        case ImageNames.editIcon.rawValue: activity = .editActivity
        case ImageNames.reminderIcon.rawValue: activity = .reminderActivity
        default:
            print("reached end of switch: error")
            
        }
        self.delegate?.activityButtonTouched(activity: activity)
    }
}
