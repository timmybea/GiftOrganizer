//
//  SettingsHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2017-11-13.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SettingsHandler: NSObject {
    
    override private init() {}
    
    static let shared = SettingsHandler()
    
    var maxBudget: Int = 0 {
        willSet {
            udStandard.set(newValue, forKey: key.maxBudget.rawValue)
        }
    }
    
    var groups = [String]() {
        willSet {
            udStandard.set(newValue, forKey: key.groups.rawValue)
        }
    }
    
    var celebrations = [String]() {
        willSet {
            udStandard.set(newValue, forKey: key.celebrations.rawValue)
        }
    }
    
    var rounding: Float = 0 {
        willSet {
            udStandard.set(newValue, forKey: key.rounding.rawValue)
        }
    }
    
    private let udStandard = UserDefaults.standard
    
    func getSettings() {
        
        maxBudget = udStandard.object(forKey: key.maxBudget.rawValue) as? Int ?? 100
        groups = udStandard.object(forKey: key.groups.rawValue) as? [String] ?? ["Colleagues", "Family", "Friends"]
        celebrations = udStandard.object(forKey: key.celebrations.rawValue) as? [String] ?? ["Baby Shower", "Birthday", "Graduation", "Wedding"]
        rounding = udStandard.object(forKey: key.rounding.rawValue) as? Float ?? 0.50
    }
    
    enum key: String {
        case maxBudget
        case groups
        case celebrations
        case rounding
    }
}
