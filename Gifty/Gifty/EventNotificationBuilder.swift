//
//  EventNotificationBuilder.swift
//  UNNotifications+CoreData
//
//  Created by Tim Beals on 2018-02-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

class EventNotificationBuilder {
    
    var event: Event {
        return self.moBuilder.event
    }
    
    var notification: EventNotification? {
        return self.moBuilder.returnEventNotification()
    }
    
    var moBuilder: EventNotificationMOBuilder
    private var unBuilder: EventNotificationUN

    private init(event: Event) {
        self.moBuilder = EventNotificationMOBuilder.newNotification(for: event, with: DataPersistenceService.shared)
        self.unBuilder = EventNotificationUNService()
    }
    
    private init(notification: EventNotification) {
        self.moBuilder = EventNotificationMOBuilder.updateNotification(notification)
        self.unBuilder = EventNotificationUNService()
    }
    
    static func newNotificaation(for event: Event) -> EventNotificationBuilder {
        return EventNotificationBuilder(event: event)
    }
    
    static func updateNotification(_ notification: EventNotification) -> EventNotificationBuilder {
        return EventNotificationBuilder(notification: notification)
    }
    
    func createNewNotification() -> EventNotification? {
        //create managed object model from prototype and add notification request
        guard let n = moBuilder.returnEventNotification() else { return nil }
        unBuilder.createUNNotification(eventNotification: n)
        return n
    }
    
    func deleteNotification() {
        guard let n = moBuilder.returnEventNotification() else { return }
        self.unBuilder.removeUNNotification(id: n.id!)
        self.moBuilder.deleteEventNotificationFromCoreData()
    }
    
    func updateNotificationCenter() {
        guard let n = moBuilder.returnEventNotification() else { return }
        self.unBuilder.removeUNNotification(id: n.id!)
        self.unBuilder.createUNNotification(eventNotification: n)
    }
    
    func saveChanges(_ dataPersistence: DataPersistence) {
        dataPersistence.saveToContext(dataPersistence.mainQueueContext)
    }
}
