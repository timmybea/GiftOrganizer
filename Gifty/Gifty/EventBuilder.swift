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
    
    private init(dataPersistence: DataPersistence) {
        if let moc = dataPersistence.mainQueueContext {
            self.event = Event(context: moc)
            self.event.id = UUID().uuidString
            self.event.isComplete = false
        }
    }
    
    private init(event: Event) {
        self.event = event
    }
    
    static func newEvent(with dataPersistence: DataPersistence) -> EventBuilder {
        let eb = EventBuilder(dataPersistence: dataPersistence)
        return eb
    }
    
    static func edit(event: Event) -> EventBuilder {
        let eb = EventBuilder(event: event)
        return eb
    }
    
    func addDate(_ date: Date) {
        self.event.date = date
        self.event.dateString = DateHandler.stringFromDate(date)
    }
    
    func changeUUID(_ uuid: String) {
        self.event.id = uuid
    }
    
    func setRecurring(_ bool: Bool) {
        self.event.recurring = bool
        self.event.recurringHead = bool
        self.event.recurringGroup = bool ? "\(event.id!)" : ""
    }
    
    func addBudget(_ budgetAmt: Float) {
        self.event.budgetAmt = budgetAmt
    }

    func addGifts(_ gifts: [Gift]?) {
        self.event.isComplete = true
        self.event.giftIds = nil

        guard let gifts = gifts else { return }
        
        var giftIds = String()
        for gift in gifts {
            giftIds += "\(gift.id!) "
            
            if gift.isCompleted == false {
                self.event.isComplete = false
            }
        }
        self.event.giftIds = giftIds
    }
    
    func addType(_ type: String) {
        self.event.type = type
    }
    
    func setToPerson(_ person: Person) {
        person.addToEvent(self.event)
    }

    func canReturnEvent(completion: @escaping(_ success: Bool, _ error: CustomErrors.createEvent?) -> ()) {
        guard self.event.type != nil else { completion(false, CustomErrors.createEvent.noEventType); return }
        guard self.event.date != nil else { completion(false, CustomErrors.createEvent.noDate); return }
        guard self.event.person != nil else { completion(false, CustomErrors.createEvent.personIsNil); return }
        completion(true, nil)
    }
    
    func buildAndReturnEvent() -> Event {
        
        return self.event
    }
    
    static func save(with dataPersistence: DataPersistence) {
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc, completion: {
                //do nothing
            })
        }
    }
    
    static func deleteAllEvents(with dataPersistence: DataPersistence) {
        guard let events = EventFRC.frc()?.fetchedObjects as [Event]? else { return }
        for event in events {
            event.managedObjectContext?.delete(event)
        }
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc, completion: {
                //do nothing
            })
        }
    }
}

extension Event {
    

    
}

