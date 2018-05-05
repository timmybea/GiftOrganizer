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
import TDBConnectivityWatchOS

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var upcomingButton: WKInterfaceButton!
    @IBOutlet var overdueButton: WKInterfaceButton!
    
    private var overdueEvents: [EventWKObject]?
    private var upcomingEvents: [EventWKObject]?
    
    private var selectedIndex = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        print("WATCH: AWAKE")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("WATCH: ACTIVATE")
        
        WatchConnectivityService.shared.activate()
        
        WatchConnectivityService.shared.sendMessage(identifier: ConnectivityIdentifier.getEvents.rawValue, payload: [:]) { (response) in
            
            if let error = response[UserInfoKey.error] as? Error {
                print("Watch Connectivity Reponse Error: \(error.localizedDescription)")
            }
            
            if let payload = response[UserInfoKey.payload] as? [String: Any] {
                
                NSKeyedUnarchiver.setClass(EventWKObject.self, forClassName: "EventWKObject")
                
                if let upcomingData = payload["upcoming"] as? Data {
                    self.upcomingEvents = NSKeyedUnarchiver.unarchiveObject(with: upcomingData) as? [EventWKObject]
                }
                
                if let overdueData = payload["overdue"] as? Data {
                    self.overdueEvents = NSKeyedUnarchiver.unarchiveObject(with: overdueData) as? [EventWKObject]
                }
                
                let datasource = self.selectedIndex == 0 ? self.upcomingEvents : self.overdueEvents
                self.updateTable(with: datasource)
            }
        }
    }
    
    private func updateTable(with source: [EventWKObject]?) {
        if let source = source {
            self.table.setNumberOfRows(source.count, withRowType: "EventWKRowController")
            
            for (index, event) in source.enumerated() {
                let row = self.table.rowController(at: index) as! EventWKRowController
                row.dateLabel.setText(DateHandler.describeDate(event.date))
                row.eventLabel.setText(event.eventName)
                row.personLabel.setText(event.personName)
                row.completeLabel.setText(self.completeText(number: event.incompleteCount))
            }
        } else {
            self.table.setNumberOfRows(0, withRowType: "EventWKRowController")
        }
    }
    
    private func completeText(number: Int) -> String {
        switch number {
        case 0:
            return "All complete"
        default:
            return "\(number) incomplete"
        }
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
        
        self.selectedIndex = 0
        updateTable(with: self.upcomingEvents)
    }
    
    
    @IBAction func overdueTouched() {
        overdueButton.setBackgroundImage(UIImage(named: "bg_white"))
        let overdue = NSAttributedString(string: "Overdue", attributes: [NSAttributedStringKey.foregroundColor : Theme.colors.lightToneTwo.color])
        overdueButton.setAttributedTitle(overdue)
        
        upcomingButton.setBackgroundImage(UIImage(named: "bg_red"))
        let upcoming = NSAttributedString(string: "Upcoming", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        upcomingButton.setAttributedTitle(upcoming)
        
        self.selectedIndex = 1
        updateTable(with: overdueEvents)
    }
    
}
