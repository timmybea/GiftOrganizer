//
//  EventToWKObjectAdapter.swift
//  GiftyBridge
//
//  Created by Tim Beals on 2018-04-29.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

public class EventToWKObjectAdapter {
    
    private var event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
    //<<<YOU ARE HERE: Make types optional. Use EventFRC to calculate incomplete gift count for initializer
    
    public func returnWKObject() -> EventWKObject {
        let output = EventWKObject()
        output.initWithData(date: event.date!,
                            eventName: event.type!,
                            personName: event.person!.fullName!,
                            isComplete: event.isComplete,
                            incompleteCount: 3)
        return output
    }
    
}
