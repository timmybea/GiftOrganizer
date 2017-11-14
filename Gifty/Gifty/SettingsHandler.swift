//
//  SettingsHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2017-11-13.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SettingsHandler {
    
    static let shared = SettingsHandler()
    
    var maxBudget: Int = 0 {
        willSet {
            UserDefaults.standard.set(newValue, forKey: key.maxBudget.rawValue)
        }
    }
    
    func getSettings() {
        if let amt = UserDefaults.standard.object(forKey: key.maxBudget.rawValue) {
            maxBudget = amt as! Int
        } else {
            maxBudget = 100
        }
    }    
    
    enum key: String {
        case maxBudget
    }
    
    
}
