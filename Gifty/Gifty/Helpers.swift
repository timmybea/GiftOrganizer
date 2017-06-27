//
//  Helpers.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

//MARK: constants






enum ImageNames: String {
    case horizontalBGGradient = "background_gradient_horizontal"
    case verticalBGGradient = "background_gradient"
    case selectedDateCircle = "selected_date_circle"
    case calendarDisplayView = "cal_display_view"
    case todayBGView = "todays_date"
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
