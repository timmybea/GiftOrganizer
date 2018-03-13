//
//  EventNotificationMOBuilder.swift
//  UNNotifications+CoreData
//
//  Created by Tim Beals on 2018-02-13.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

//Model Object Builder
class EventNotificationMOBuilder {
    
    var event: Event
    private var eventNotification: EventNotification?
    
    //Factory methods
    private init(for event: Event, with dataPersistence: DataPersistence) {
        self.event = event
        guard let moc = dataPersistence.mainQueueContext else { return }
        
        self.eventNotification = EventNotification(context: moc)
        self.eventNotification?.id = UUID().uuidString
        event.addToEventNotification(self.eventNotification!)
    }
    
    private init(eventNotification: EventNotification) {
        self.eventNotification = eventNotification
        self.event = (self.eventNotification?.event)!
    }
    
    static func newNotification(for event: Event, with dataPersistence: DataPersistence) -> EventNotificationMOBuilder {
        return EventNotificationMOBuilder(for: event, with: dataPersistence)
    }
    
    static func updateNotification(_ notification: EventNotification) -> EventNotificationMOBuilder{
        return EventNotificationMOBuilder(eventNotification: notification)
    }
    
    //changing values for properties
    func addTitle(_ title: String) {
        self.eventNotification?.eventTitle = title
    }
    
    func addDate(_ date: Date) {
        self.eventNotification?.date = date
    }
    
    func addMessage(_ message: String) {
        self.eventNotification?.message = message
    }
    
    private func canReturnEventNotification() -> Bool {
        guard self.eventNotification?.eventTitle != nil else { return false }
        guard self.eventNotification?.message != nil else { return false }
        guard self.eventNotification?.id != nil else { return false }
        guard self.eventNotification?.date != nil else { return false }
        return true
    }
    
    func returnEventNotification() -> EventNotification? {
        return canReturnEventNotification() ? self.eventNotification : nil
    }
    
    func deleteEventNotificationFromCoreData() {
        if self.eventNotification != nil {
            self.eventNotification!.managedObjectContext?.delete(self.eventNotification!)
        }
    }
}
