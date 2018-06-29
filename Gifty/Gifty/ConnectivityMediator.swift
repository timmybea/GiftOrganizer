//
//  ConnectivityMediator.swift
//  Gifty
//
//  Created by Tim Beals on 2018-05-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

class ConnectivityMediator {
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(getEvent(for:)), name: Notifications.names.actionStateChanged.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEvent(for:)), name: Notifications.names.eventDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEvent(for:)), name: Notifications.names.newEventCreated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEvent(for:)), name: Notifications.names.personDeleted.name, object: nil)
    }
    
    static let shared = ConnectivityMediator()
    
    @objc func getEvent(for notification: Notification) {
        let payload = getEventData()
        WatchConnectivityService.shared.sendMessage(identifier: ConnectivityIdentifier.updateEventData.rawValue, payload: payload)
    }
    
    
    func getEventData() -> [String: Any] {
        
        var payload = [String: Any]()
        
        guard let frc = EventFRC.frc(), let events = frc.fetchedObjects else {
            return payload
        }
        
        EventFRC.sortEventsTodayExtension(events: events) { (upcoming, overdue) in
            
            var wkUpcoming = [EventWKObject]()
            if let upcoming = upcoming {
                for event in upcoming {
                    if let wke = EventToWKObjectAdapter(event: event).returnWKObject() {
                        wkUpcoming.append(wke)
                    }
                }
            }
            
            var wkOverdue = [EventWKObject]()
            if let overdue = overdue {
                for event in overdue {
                    if let wke = EventToWKObjectAdapter(event: event).returnWKObject() {
                        wkOverdue.append(wke)
                    }
                }
            }
            
            NSKeyedArchiver.setClassName("EventWKObject", for: EventWKObject.self)
            let archivedUpcoming = NSKeyedArchiver.archivedData(withRootObject: wkUpcoming)
            let archivedOverdue = NSKeyedArchiver.archivedData(withRootObject: wkOverdue)
            
            payload = ["upcoming": archivedUpcoming, "overdue": archivedOverdue]
        }
        return payload
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
