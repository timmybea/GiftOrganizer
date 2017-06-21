//
//  Helpers.swift
//  JTCalendarProgrammatic
//
//  Created by Tim Beals on 2017-06-20.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

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

class ColorManager {
    
    static var lightText = UIColor.colorFrom(r: 249, g: 175, b: 186)
    
}


extension UIColor {
    
    static func colorFrom(r: Int, g: Int, b: Int) -> UIColor {
        
        let red = Float(r) / 255
        let green = Float(g) / 255
        let blue = Float(b) / 255
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
    }
    
}
