//
//  DateHandler.swift
//  CalendarModelTest
//
//  Created by Tim Beals on 2017-06-22.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

public class DateHandler: NSObject {
   
    //MARK: String to date and viceversa
    //NOTE: There were threading issues with having date formatter as a property, so changed to func
    private static func dateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar.current
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.locale = Calendar.current.locale
        return df
    }
    
    public static func dateWith(dd: String, MM: String, yyyy: String) -> Date? {
        let df = dateFormatter()
        df.dateFormat = "yyyy MM dd"
        return df.date(from: "\(yyyy) \(MM) \(dd)")
    }
    
    public static func dateWith(yyyy: String, MM: String, dd: String, HH: String, mm: String, ss: String) -> Date? {
        let df = dateFormatter()
        df.dateFormat = "yyyy MM dd HH:mm:ss"
        return df.date(from: "\(yyyy) \(MM) \(dd) \(HH)-\(mm)-\(ss)")
    }
    
    public static func dateFromDateString(_ dateString: String) -> Date? {
        let dateComponents = dateString.components(separatedBy: " ")
        guard let date = DateHandler.dateWith(dd: dateComponents[2], MM: dateComponents[1], yyyy: dateComponents[0]) else { return nil }
        return date
    }
    
    public static func stringYear() -> String {
        let df = dateFormatter()
        df.dateFormat = "YYYY"
        return df.string(from: Date())
    }
    
    public static func describeDate(_ date: Date) -> String {
        let df = dateFormatter()
        df.dateStyle = .long
        return df.string(from: date)
    }
    
    public static func stringFromDate(_ date: Date) -> String {
        let df = dateFormatter()
        df.dateFormat = "yyyy MM dd"
        return df.string(from: date)
    }
    
    public static func stringMonthAbb(from date: Date) -> String {
        let df = dateFormatter()
        df.dateFormat = "MMM"
        return df.string(from: date)
    }
    
    public static func stringMonth(from date: Date) -> String {
        let df = dateFormatter()
        df.dateFormat = "MM"
        return df.string(from: date)
    }
    
    public static func stringDayNum(from date: Date) -> String {
        let df = dateFormatter()
        df.dateFormat = "dd"
        return df.string(from: date)
    }
    
    public static func sameComponent(_ component: Calendar.Component, date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        if calendar.component(.year, from: date1) == calendar.component(.year, from: date2) {
            if calendar.component(component, from: date1) == calendar.component(component, from: date2) {
                return true
            }
        }
        return false
    }    

    //MARK: Handle time zone
    public static func localTimeFromUTC(_ date: Date) -> Date {
        let todayGMT = Date()
        let secondsFromGMT = Calendar.current.timeZone.secondsFromGMT()
        return todayGMT.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
    
    public static func UTCTimeFromLocal(_ date: Date) -> Date {
        let secondsFromGMT = Calendar.current.timeZone.secondsFromGMT()
        return date.addingTimeInterval(TimeInterval(secondsFromGMT * -1))
    }
}
