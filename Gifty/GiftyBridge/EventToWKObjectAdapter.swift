//
//  EventToWKObjectAdapter.swift
//  GiftyBridge
//
//  Created by Tim Beals on 2018-04-29.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

public class EventToWKObjectAdapter {
    
    private var event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
    //<<<YOU ARE HERE: Make types optional. Use EventFRC to calculate incomplete gift count for initializer
    
    public func returnWKObject() -> EventWKObject? {
        guard let date = event.date, let eventName = event.type, let personName = event.person?.fullName else { return nil }

        let incompleteCount = countIncompleteActions()
        return EventWKObject(date: date, eventName: eventName, personName: personName, isComplete: event.isComplete, incompleteCount: incompleteCount)
    }
    
    private func countIncompleteActions() -> Int {
        var count = 0
        if let gifts = GiftFRC.getGifts(for: self.event) {
            for gift in gifts {
                if !gift.isCompleted {
                    count += 1
                }
            }
        }
        return count
    }
    
}
