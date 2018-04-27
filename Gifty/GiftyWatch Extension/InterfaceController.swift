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

class InterfaceController: WKInterfaceController {
    
    var redBG = UIImage(named: "rect_red")
    var whiteBG = UIImage(named: "rect_white")
    
    @IBOutlet var upcomingButton: WKInterfaceButton!
    @IBOutlet var overdueButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("WATCH: AWAKE")
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
    
        upcomingButton.setBackgroundImage(#imageLiteral(resourceName: "rect_white"))
        
        
    //let uptitle = NSAttributedString(string: "Upcoming", attributes: [Color: Theme])
//        upcomingButton.setAttributedTitle(<#T##attributedTitle: NSAttributedString?##NSAttributedString?#>)
        overdueButton.setBackgroundImage(#imageLiteral(resourceName: "rect_red"))
        
    }
    
    
    @IBAction func overdueTouched() {
        
        
    }
    
}
