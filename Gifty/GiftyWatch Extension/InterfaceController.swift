//
//  InterfaceController.swift
//  GiftyWatch Extension
//
//  Created by Tim Beals on 2018-04-24.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import WatchKit
import Foundation
import GiftyWatchBridge
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var upcomingButton: WKInterfaceButton!
    @IBOutlet var overdueButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        print("WATCH: AWAKE")
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("WATCH: ACTIVATE")
        

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        print("WATCH: DEACTIVATE")
    }
    
    
    @IBAction func upcomingTouched() {
    
        upcomingButton.setBackgroundImage(UIImage(named: "bg_white"))
        let upcoming = NSAttributedString(string: "Upcoming", attributes: [NSAttributedStringKey.foregroundColor : Theme.colors.lightToneTwo.color])
        upcomingButton.setAttributedTitle(upcoming)
        
        overdueButton.setBackgroundImage(UIImage(named: "bg_red"))
        let overdue = NSAttributedString(string: "Overdue", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        overdueButton.setAttributedTitle(overdue)
    }
    
    
    @IBAction func overdueTouched() {
        overdueButton.setBackgroundImage(UIImage(named: "bg_white"))
        let overdue = NSAttributedString(string: "Overdue", attributes: [NSAttributedStringKey.foregroundColor : Theme.colors.lightToneTwo.color])
        overdueButton.setAttributedTitle(overdue)
        
        upcomingButton.setBackgroundImage(UIImage(named: "bg_red"))
        let upcoming = NSAttributedString(string: "Upcoming", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        upcomingButton.setAttributedTitle(upcoming)
    }
    
}

extension InterfaceController {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        let loadedData = message["progData"]
        
        
    }
}
