//
//  Person+Extension.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

extension Person {
    
    func hasBirthday() -> Bool {
        guard let events = self.event?.allObjects as? [Event] else { return false }
        
        for event in events {
            if event.type == "Birthday" {
                return true
            }
        }
        return false
    }
}
