//
//  SettingsHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2017-11-13.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

//MARK: Properties
class SettingsHandler {
    
    //public properties
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
    
    var showInterstitials: Bool = true {
        willSet {
            udStandard.set(newValue, forKey: key.showInterstitials.rawValue)
        }
    }
    
    var launchCount: Int = 0 {
        willSet {
            udStandard.set(newValue, forKey: key.launchCount.rawValue)
        }
    }
    

    //private
    private init() {}
    
    private let udStandard = UserDefaults.standard
    
}

//MARK: Public Interface
extension SettingsHandler {
    
    func getSettings() {
        launchCount = udStandard.object(forKey: key.launchCount.rawValue) as? Int ?? 0
        maxBudget = udStandard.object(forKey: key.maxBudget.rawValue) as? Int ?? 100
        groups = udStandard.object(forKey: key.groups.rawValue) as? [String] ?? ["Colleagues", "Family", "Friends"]
        celebrations = udStandard.object(forKey: key.celebrations.rawValue) as? [String] ?? ["Baby Shower", "Birthday", "Graduation", "Wedding"]
        rounding = udStandard.object(forKey: key.rounding.rawValue) as? Float ?? 0.50
        showInterstitials = udStandard.object(forKey: key.showInterstitials.rawValue) as? Bool ?? true
        
        incrementLaunchCount()
    }
 
}

//MARK: Private Methods
extension SettingsHandler {
    
    private func incrementLaunchCount() {
        launchCount += 1
    }
    
    private enum key: String {
        case launchCount
        case maxBudget
        case groups
        case celebrations
        case rounding
        case showInterstitials
    }
}
