//
//  ColorManager.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ColorManager: NSObject {

    static var tabBarPurple = UIColor.colorWithVals(r: 94, g: 5, b: 70)
    static var lightText = UIColor.colorWithVals(r: 249, g: 175, b: 186)
    static var highlightedText = UIColor.colorWithVals(r: 206, g: 78, b: 120)
    static var yellow = UIColor.colorWithVals(r: 255, g: 210, b: 92)
}

extension UIColor {
    
    static func colorWithVals(r: Int, g: Int, b: Int) -> UIColor {
        let red = Float(r) / 255
        let green = Float(g) / 255
        let blue = Float(b) / 255
        return UIColor(colorLiteralRed: red, green: green , blue: blue, alpha: 1)
    }
    
    
    
}
