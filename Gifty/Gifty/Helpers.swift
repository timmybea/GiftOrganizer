//
//  Helpers.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

//MARK: layout constants
let pad: CGFloat = 16
let smallPad: CGFloat = 12


var currencySymbol: String = {
    if let country = (Locale.current as NSLocale).countryCode {
        switch country {
        case "GB": return "£"
        case "GH": return "₵"
        case "IN": return "₹"
        case "IE", "MT": return "€"
        case "KE": return "KSh"
        case "MU", "NP", "SC": return "Rs"
        case "NA", "ZA": return "R"
        case "NG": return "₦"
        case "PG": return "K"
        case "PH": return "₱"
        default: return "$"
        }
    } else {
        return "$"
    }
}()

let safeAreaTop: CGFloat = {
    guard let a = UIApplication.shared.keyWindow?.safeAreaInsets.top else { return 20.0 } // the safe area or the status bar height
    return a > 0.0 ? a : 20.0
}()

enum ImageNames: String {
    case horizontalBGGradient = "bg_horizontal"
    case verticalBGGradient = "background_gradient"
    case selectedDateCircle = "selected_date_circle"
    case reminderIcon = "reminder_icon"
    case editIcon = "edit_icon"
    case calendarDisplayView = "cal_display_view"
    case todayBGView = "todays_date"
    case profileImagePlaceHolder = "profile_image"
    case profileImagePlaceHolderTouched = "profile_image_touched"
    case personIcon = "person_icon"
    case addGiftImage = "add_gift_image"
    case dropdownTriangle = "dropdown_triangle"
    case addButton = "add_button"
    case addGift = "add_gift"
    case addGreetingCard = "add_greeting_card"
    case addPhoneCall = "add_phone_call"
    case removeIcon = "remove_icon"
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
    case settingsIcon = "settings"
    case expandArrow = "expand_arrow"
    case gift = "gift"
    case giftIcon = "gift_icon"
    case starOutline = "star_outline"
    case starFill = "star_fill"
    case copyIcon = "copy_icon"
}

struct Notifications {
    enum names {
        case actionStateChanged
        case newEventCreated
        case eventDeleted
        case personDeleted
    
        var name: NSNotification.Name {
            switch self {
            case .actionStateChanged: return NSNotification.Name.init("actionStateChanged")
            case .newEventCreated: return NSNotification.Name.init("newEventCreated")
            case .eventDeleted: return NSNotification.Name.init("eventDeleted")
            case .personDeleted: return NSNotification.Name.init("personDeleted")
            }
        }
    }
}

struct CustomErrors {
    enum createEvent {
        case noDate
        case noEventType
        case personIsNil
        case changesMade
        case noBudget
        
        var description: String {
            switch self {
            case .noBudget: return "Please create a budget for your event"
            case .noDate: return "Please select a date for your event."
            case .noEventType: return "Please select an event type."
            case .personIsNil: return "Please select a person for your event."
            case .changesMade: return "If you continue with this action, you will lose changes you have made"
            }
        }
    }
    
    enum createPerson {
        case deletePerson
        case noFirstName
        case noGroup
        case noPerson
        case nameChange
        
        var description: String {
            switch self {
            case .deletePerson: return "This action will delete the event and all of the gifts assigned to it."
            case .noFirstName: return "Please add a first name"
            case .noGroup: return "Please add a group"
            case .noPerson: return "There is no person to update"
            case .nameChange: return "This action will change the name of your person"
            }
        }
    }
    
    enum createGift {
        case noName
        case noBudget
        case noPerson
        
        var description: String {
            switch self {
            case .noName: return "Please create a name for your gift"
            case .noBudget: return "Please create a budget for your gift"
            case .noPerson: return "Please assign your gift to a person before saving."
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
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Theme.fonts.titleText.font, NSAttributedStringKey.foregroundColor: UIColor.white]
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
        placeHolder = NSMutableAttributedString(string:text, attributes: [NSAttributedStringKey.font:font])
        
        // Set the color
        placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:NSRange(location:0,length:text.count))
        
        // Add attribute
        self.attributedPlaceholder = placeHolder
    }
}

extension UILabel {
    public static func createMediumLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = Theme.fonts.boldSubtitleText.font
        label.textAlignment = .left
        return label
    }
}

extension Float {
 
    var dollarString:String {
        return String(format: "\(currencySymbol)%.2f", self)
    }

}
