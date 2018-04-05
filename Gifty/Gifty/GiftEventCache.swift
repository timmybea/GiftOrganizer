//
//  GiftEventCache.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge


class GiftEventCache {
    
    private static var cache = [String: Event]()
    
    static func loadCache(for gifts: [Gift], completion: () -> ()) {
        
        cache.removeAll()
        
        for g in gifts {
            
            guard let eventId = g.eventId, let context = g.managedObjectContext else { continue }
            
            if !cache.keys.contains(eventId) {
                
                if let event = EventFRC.getEvent(for: eventId, with: context) {
                    cache[eventId] = event
                }
                
            }
        }
        completion()
    }
    
    static func event(with id: String) -> Event? {
        return cache[id]
    }
}
