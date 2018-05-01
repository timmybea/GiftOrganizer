//
//  WatchConnectivityService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-30.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge
import WatchConnectivity

class WatchConnectivityService: NSObject {

    enum WatchConnectivityStatus {
        case paired
        case notPaired
        case appNotInstalled
        case notSupported
    }
    
    private var status: WatchConnectivityStatus = .notPaired {
        didSet {
            print("WCS: \(status)")
        }
    }
    private var lastMessageTime: CFAbsoluteTime = 0.0
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: Notifications.names.newEventCreated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: Notifications.names.eventDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: Notifications.names.personDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: Notifications.names.actionStateChanged.name, object: nil)
    }
    
    static var shared = WatchConnectivityService()
    
    func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            if session.isPaired {
                self.status = .paired
            }
            
            if !session.isWatchAppInstalled {
                self.status = .appNotInstalled
            }
            
        } else {
            self.status = .notSupported
        }
    }
    
    func getMsgData() -> [String: Data]? {
        
        guard let frc = EventFRC.frc(), let events = frc.fetchedObjects else { return nil }
        
        var output = [String: Data]()
        
        EventFRC.sortEventsTodayExtension(events: events) { (upcoming, overdue) in
            
            var upcomingWKObjects = [EventWKObject]()
            if let upcoming = upcoming {
                for e in upcoming {
                    let adapter = EventToWKObjectAdapter(event: e)
                    if let wkObject = adapter.returnWKObject() {
                        upcomingWKObjects.append(wkObject)
                    }
                }
            }
            
            var overdueWKObjects = [EventWKObject]()
            if let overdue = overdue {
                for e in overdue {
                    let adapter = EventToWKObjectAdapter(event: e)
                    if let wkObject = adapter.returnWKObject() {
                        overdueWKObjects.append(wkObject)
                    }
                }
            }
            NSKeyedArchiver.setClassName("EventWKObject", for: EventWKObject.self)
            let upcomingData = NSKeyedArchiver.archivedData(withRootObject: upcomingWKObjects)
            let overdueData = NSKeyedArchiver.archivedData(withRootObject: overdueWKObjects)
            
            output["upcomingWKEvent"] = upcomingData
            output["overdueWKEvent"] = overdueData
        }
        return output
    }
    
    func sendWatchMessage(_ message: [String: Data]) {
        if status != .paired {
            activateSession()
        }
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessageTime + 0.5 > currentTime { return }
        
        if WCSession.default.isReachable {
//            do {
//               try WCSession.default.updateApplicationContext(message)
//            } catch {
//                print("WCS: \(error.localizedDescription)")
//            }
            WCSession.default.sendMessage(message, replyHandler: { (reply) in
                print("\(reply)")
            })
        }
        lastMessageTime = CFAbsoluteTimeGetCurrent()
    }
    
    @objc func coreDataUpdated() {
        if let message = getMsgData() {
            sendWatchMessage(message)
        }
    }
    
}

extension WatchConnectivityService: WCSessionDelegate {
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {

        if message["getEventWKData"] != nil {
            if let returnData = getMsgData() {
                replyHandler(returnData)
            }
        } else {
            replyHandler([:])
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WATCH CONNECTIVITY SERVICE: Activation Did Complete with state: \(activationState.rawValue)")
        if let message = getMsgData() {
            sendWatchMessage(message)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WATCH CONNECTIVITY SERVICE: Session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WATCH CONNECTIVITY SERVICE: Session did deactivate")
    }
}
