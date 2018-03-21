//
//  EventBuilder.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class EventBuilder {
    
    private var event: Event!
    
    init(dataPersistence: DataPersistence) {
        if let moc = dataPersistence.mainQueueContext {
            self.event = Event(context: moc)
            self.event.id = UUID().uuidString
        }
    }
    
    func addDate(_ date: Date) {
        self.event.date = date
    }
    
    func addRecurring(_ bool: Bool) {
        //not in model yet
    }
    
    func addBudget(_ budgetAmt: Float) {
        self.event.budgetAmt = budgetAmt
    }

    func addType(_ type: String) {
        self.event.type = type
    }

    func canReturnEvent(completion: @escaping(_ success: Bool, _ error: CustomErrors.createEvent?) -> ()) {
        guard self.event.type != nil else { completion(false, CustomErrors.createEvent.noEventType); return }
        guard self.event.date != nil else { completion(false, CustomErrors.createEvent.noDate); return }
        guard self.event.person != nil else { completion(false, CustomErrors.createEvent.personIsNil); return }
        guard self.event.budgetAmt != nil else { completion(false, CustomErrors.createEvent.noBudget); return }
        completion(true, nil)
    }
    
    
    
}

