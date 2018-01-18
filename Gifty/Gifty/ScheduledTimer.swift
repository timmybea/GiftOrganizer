//
//  ScheduledTimer.swift
//  ScheduledTimer
//
//  Created by Tim Beals on 2017-06-24.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol SchedultedTimerDelegate {
    func executeAtMidnight()
}

class ScheduledTimer: NSObject {

    var delegate: SchedultedTimerDelegate?
    
    override init() {
        super.init()
        
        let now = DateHandler.localTimeFromUTC(Date())
        
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day, .hour], from: now as Date)
        
        if let year = todayComponents.year, let month = todayComponents.month, let day = todayComponents.day {
            
            let yearString: String = "\(year)"
            let monthString: String = month < 10 ? "0\(month)" : "\(month)"
            let dayString: String = day < 10 ? "0\(day)" : "\(day)"
            
            let localFire = DateHandler.dateWith(yyyy: yearString, MM: monthString, dd: dayString, HH: "00", mm: "00", ss: "00")
            let UTCFire = DateHandler.UTCTimeFromLocal(localFire!)
            let oneDay: Double = 60 * 60 * 24
            let timer = Timer(fireAt: UTCFire, interval: oneDay, target: self, selector: #selector(midnightEx), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    @objc func midnightEx() {
        if self.delegate != nil {
            self.delegate?.executeAtMidnight()
        }
    }
    
    
    
    
}
