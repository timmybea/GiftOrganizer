//
//  CurrencyHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2017-09-17.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CurrencyHandler: NSObject {

    static private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static func round(_ value: Float, toNearest: Float) -> Float {
    
        return Darwin.round(value / toNearest) * toNearest
    
    }
    
    static func formattedString(for value: Float) -> String {

        return numberFormatter.string(from: value as NSNumber)!
    
    }
    
    
}
