//
//  DateHandler.swift
//  CalendarModelTest
//
//  Created by Tim Beals on 2017-06-22.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class DateHandler: NSObject {
   
    //MARK: String to date and viceversa
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
    
    static func dateFromDateString(_ dateString: String) -> Date? {
        let dateComponents = dateString.components(separatedBy: " ")
        guard let date = DateHandler.dateWith(dd: dateComponents[2], MM: dateComponents[1], yyyy: dateComponents[0]) else { return nil }
        return date
    }
    
    static func stringFromDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.string(from: date)
    }
    
    static func stringMonthAbb(from date: Date) -> String {
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    static func stringMonth(from date: Date) -> String {
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
    
    static func stringDayNum(from date: Date) -> String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    

    //MARK: Handle time zone
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
