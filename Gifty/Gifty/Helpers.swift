//
//  Helpers.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

//MARK: layout constants
let pad: CGFloat = 16
let smallPad: CGFloat = 12

enum ImageNames: String {
    case horizontalBGGradient = "background_gradient_horizontal"
    case verticalBGGradient = "background_gradient"
    case selectedDateCircle = "selected_date_circle"
    case calendarDisplayView = "cal_display_view"
    case todayBGView = "todays_date"
    case profileImagePlaceHolder = "profile_image"
    case profileImagePlaceHolderTouched = "profile_image_touched"
    case dropdownTriangle = "dropdown_triangle"
    case addButton = "add_button"
    case addGift = "add_gift"
    case addGreetingCard = "add_greeting_card"
    case addPhoneCall = "add_phone_call"
    case calendarIcon = "calendar"
    case peopleIcon = "people"
    case defaultProfileBlock = "default_profile_block"
    case eventIcon = "event_icon"
    case back = "back"
    case completeIcon = "complete_icon"
    case incompleteIcon = "incomplete_icon"
    case swipeIcon = "swipe_icon"
    case calendarSpot = "cal_spot"
    case budget = "budget"
}

struct Notifications {
    
    enum Names {
        case actionStateChanged
        case newEventCreated
        case eventDeleted
    
        var Name: NSNotification.Name {
            switch self {
            case .actionStateChanged: return NSNotification.Name.init("actionStateChanged")
            case .newEventCreated: return NSNotification.Name.init("newEventCreated")
            case .eventDeleted: return NSNotification.Name.init("eventDeleted")
            }
        }
    }
}


extension UINavigationController {
    
    static func setupCustomNavigationController(_ viewController: CustomViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.view.addSubview(viewController.titleLabel)
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName: Theme.fonts.titleText.font, NSForegroundColorAttributeName: UIColor.white]
        
        return navigationController
    }
}

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.16
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 2
        
    }
    
    func bounceAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: { 
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UITextField {
    
    func placeholderWith(string: String, color: UIColor, font: UIFont = Theme.fonts.mediumText.font) {
        
        var placeHolder = NSMutableAttributedString()
        let text = string
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:text, attributes: [NSFontAttributeName:font])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: color, range:NSRange(location:0,length:text.characters.count))
        
        // Add attribute
        self.attributedPlaceholder = placeHolder
    }
}

extension Float {
 
    var dollarString:String {
        return String(format: "$%.2f", self)
    }

}
