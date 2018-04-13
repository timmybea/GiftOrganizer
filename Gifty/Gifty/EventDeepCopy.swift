//
//  EventDeepCopy.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class EventDeepCopy {
    
    private let originalEvent: Event
    private let eventBuilder = EventBuilder.newEvent(with: DataPersistenceService.shared)
    
    init(event: Event) {
        self.originalEvent = event
    }
    
    
    func copyRecurringEvent() -> Event? {
    
        eventBuilder.addType(originalEvent.type!)
        
        let yearsToAdd = 1 // This could change to monthly or weekly?
        if let newDate = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: originalEvent.date!) {
            eventBuilder.addDate(newDate)
        }
        eventBuilder.addBudget(originalEvent.budgetAmt)
        eventBuilder.setToPerson(originalEvent.person!)
        
        var output = Event()
        eventBuilder.canReturnEvent { (success, customError) in
            
            if success {
                output = self.eventBuilder.buildAndReturnEvent()
            } else if let e = customError {
                print(e.description)
                output = self.eventBuilder.buildAndReturnEvent()
            }
        }
        
        output.recurring = true
        output.recurringHead = true
        originalEvent.recurringHead = false
        
        let updatedGroup = "\(String(describing: originalEvent.recurringGroup!)) \(String(describing: output.id!))"
        output.recurringGroup = updatedGroup
        originalEvent.recurringGroup = updatedGroup
        
        return output
    }
}
