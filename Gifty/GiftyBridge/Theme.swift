//
//  Theme.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-21.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

public struct Theme {
    
    public enum colors {
        case offWhite
        case sand
        case darkPurple
        case buttonPurple
        case lightToneOne
        case lightToneTwo
        case lightToneThree
        case lightToneFour
        case yellow
        case charcoal
        case completedGreen
        case textLightTone
        
        public var color: UIColor {
            switch self {
            case .buttonPurple: return UIColor.colorWithVals(r: 139, g: 24, b: 91)
            case .offWhite: return UIColor.colorWithVals(r: 249, g: 249, b: 250)
            case .darkPurple: return UIColor.colorWithVals(r: 94, g: 5, b: 70)
            case .lightToneOne: return UIColor.colorWithVals(r: 249, g: 175, b: 186)
            case .lightToneTwo: return UIColor.colorWithVals(r: 206, g: 78, b: 120)
            case .lightToneThree: return UIColor.colorWithVals(r: 166, g: 54, b: 83)
            case .lightToneFour: return UIColor.colorWithVals(r: 235, g: 122, b: 144)
            case .yellow: return UIColor.colorWithVals(r: 255, g: 210, b: 92)
            case .charcoal: return UIColor.colorWithVals(r: 62, g: 62, b: 62)
            case .completedGreen: return UIColor.colorWithVals(r: 137, g: 219, b: 112)
            case .sand: return UIColor.colorWithVals(r: 229, g: 180, b: 141)
            case .textLightTone: return UIColor.colorWithVals(r: 252, g: 227, b: 230)
            }
        }
    }

    public enum fonts {
        case titleText
        case subtitleText
        case boldSubtitleText
        case mediumText
        case smallText
        case dateDay
        case dateMonth
        
        public var font: UIFont {
            switch self {
            case .titleText: return UIFont.systemFont(ofSize: 24)
            case .boldSubtitleText: return UIFont.boldSystemFont(ofSize: 18)
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
    
    public static func colorWithVals(r: Int, g: Int, b: Int) -> UIColor {
        let red = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue = CGFloat(b) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}


