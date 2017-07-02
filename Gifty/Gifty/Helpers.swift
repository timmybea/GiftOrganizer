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
}


extension UINavigationController {
    
    static func setupCustomNavigationController(_ viewController: CustomViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        navigationController.view.addSubview(viewController.titleLabel)

        return navigationController
    }
}

extension UIView {
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
    
    func placeholderWith(string: String, color: UIColor, font: UIFont = FontManager.mediumText) {
        
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
