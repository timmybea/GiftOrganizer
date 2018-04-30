//
//  WatchConnectivityService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-30.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchConnectivityService: NSObject {

    enum WatchConnectivityStatus {
        case paired
        case notPaired
        case appNotInstalled
        case notSupported
    }
    
    private var status: WatchConnectivityStatus = .notPaired
    private var lastMessageTime: CFAbsoluteTime = 0.0
    
    private override init() {
        super.init()
        self.activateSession()
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
    
    func sendWatchMessage(_ msgData: Data) {
        if status != .paired {
            activateSession()
        }
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessageTime + 0.5 > currentTime { return }
        
        if WCSession.default.isReachable {
            let message = ["eventWKData": msgData]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        lastMessageTime = CFAbsoluteTimeGetCurrent()
    }
    
}

extension WatchConnectivityService: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
}
