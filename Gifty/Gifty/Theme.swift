//
//  Theme.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-21.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

struct Theme {
    
    enum colors {
        case offWhite
        case darkPurple
        case buttonPurple
        case lightToneOne
        case lightToneTwo
        case yellow
        case charcoal
        case completedGreen
        
        var color: UIColor {
            switch self {
            case .buttonPurple: return UIColor.colorWithVals(r: 139, g: 24, b: 91)
            case .offWhite: return UIColor.colorWithVals(r: 249, g: 249, b: 250)
            case .darkPurple: return UIColor.colorWithVals(r: 94, g: 5, b: 70)
            case .lightToneOne: return UIColor.colorWithVals(r: 249, g: 175, b: 186)
            case .lightToneTwo: return UIColor.colorWithVals(r: 206, g: 78, b: 120)
            case .yellow: return UIColor.colorWithVals(r: 255, g: 210, b: 92)
            case .charcoal: return UIColor.colorWithVals(r: 62, g: 62, b: 62)
            case .completedGreen: return UIColor.colorWithVals(r: 137, g: 219, b: 112)
            }
        }
    }

    enum fonts {
     case titleText
        case subtitleText
        case mediumText
        case smallText
        case dateDay
        case dateMonth
        
        var font: UIFont {
            switch self {
            case .titleText: return UIFont.systemFont(ofSize: 24)
            case .subtitleText: return UIFont.systemFont(ofSize: 18)
            case .mediumText: return UIFont.systemFont(ofSize: 16)
            case .smallText: return UIFont.systemFont(ofSize: 13)
            case .dateDay: return UIFont(name: "AvenirNext-Bold", size: 22)!
            case .dateMonth: return UIFont(name: "AvenirNext-Bold", size: 13)!
            }
        }
    }
}

extension UIColor {
    
    static func colorWithVals(r: Int, g: Int, b: Int) -> UIColor {
        let red = Float(r) / 255
        let green = Float(g) / 255
        let blue = Float(b) / 255
        return UIColor(colorLiteralRed: red, green: green , blue: blue, alpha: 1)
    }
}
