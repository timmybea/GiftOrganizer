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
    private static var sortedEvents = [(String, Event)]()
    
    static func loadCache(for gifts: [Gift], completion: () -> ()) {
        
        cache.removeAll()
        
        for g in gifts {
            
            guard let eventId = g.eventId, let context = g.managedObjectContext else { continue }
            
            if !cache.keys.contains(eventId) {
                
                if let event = EventFRC.getEvent(forId: eventId, with: context) {
                    cache[eventId] = event
                }
                
            }
        }
        completion()
    }
    
    static func event(withId id: String) -> Event? {
        return cache[id]
    }
    
    static func returnOrderedGiftIds() -> [String] {
        sortedEvents = cache.sorted() { $0.value.date! > $1.value.date! }
        return sortedEvents.map() { $0.0 }
    }
}
