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
let smallPad: CGFloat = 8

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
    case defaultProfileBlock = "default_profile_block"
    case eventIcon = "event_icon"
    case back = "back"
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
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
       // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
       // self.layer.shouldRasterize = true
        
        //self.layer.rasterizationScale = UIScreen.main.scale
        
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
