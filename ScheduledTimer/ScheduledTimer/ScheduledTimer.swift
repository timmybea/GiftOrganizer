//
//  ScheduledTimer.swift
//  ScheduledTimer
//
//  Created by Tim Beals on 2017-06-24.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ScheduledTimer: NSObject {

    static func setup() {

        let now = DateHandler.localTimeFromUTC(Date())
        
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day, .hour], from: now as Date)

        if let year = todayComponents.year, let month = todayComponents.month, let day = todayComponents.day {

            let yearString: String = "\(year)"
            let monthString: String = month < 10 ? "0\(month)" : "\(month)"
            let dayString: String = day < 10 ? "0\(day)" : "\(day)"
            
            let localFire = DateHandler.dateWith(yyyy: yearString, MM: monthString, dd: dayString, HH: "15", mm: "35", ss: "00")
            let UTCFire = DateHandler.UTCTimeFromLocal(localFire!)
            print(UTCFire)
            
            let timer = Timer(fireAt: UTCFire, interval: 10.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    static func sayHello() {
        print("Hello world")
    }
    
    
    
    
    
}
