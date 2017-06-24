//
//  DateHandler.swift
//  CalendarModelTest
//
//  Created by Tim Beals on 2017-06-22.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class DateHandler: NSObject {
    
    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar.current
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.locale = Calendar.current.locale
        return df
    }()

    static func dateWith(dd: String, MM: String, yyyy: String) -> Date? {
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.date(from: "\(yyyy) \(MM) \(dd)")
    }
    
    static func dateWith(yyyy: String, MM: String, dd: String, HH: String, mm: String, ss: String) -> Date? {
        dateFormatter.dateFormat = "yyyy MM dd HH:mm:ss"
        return dateFormatter.date(from: "\(yyyy) \(MM) \(dd) \(HH)-\(mm)-\(ss)")
    }
    
    static func stringFromDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
// MARK: New!
    static func localTimeFromUTC(_ date: Date) -> Date {
        let todayGMT = Date()
        let secondsFromGMT = Calendar.current.timeZone.secondsFromGMT()
        return todayGMT.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
    
    static func UTCTimeFromLocal(_ date: Date) -> Date {
        let secondsFromGMT = Calendar.current.timeZone.secondsFromGMT()
        return date.addingTimeInterval(TimeInterval(secondsFromGMT * -1))
    }
    
    
}
