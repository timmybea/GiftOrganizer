//
//  ColorManager.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ColorManager: NSObject {

    static var violet = UIColor.colorWithVals(r: 149, g: 79, b: 175)
    
}

extension UIColor {
    
    static func colorWithVals(r: Int, g: Int, b: Int) -> UIColor {
        let red = Float(r) / 255
        let green = Float(g) / 255
        let blue = Float(b) / 255
        return UIColor(colorLiteralRed: red, green: green , blue: blue, alpha: 1)
    }
    
}
