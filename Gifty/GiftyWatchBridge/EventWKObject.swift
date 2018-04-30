//
//  EventWKObject.swift
//  GiftyWatchBridge
//
//  Created by Tim Beals on 2018-04-29.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class EventWKObject: NSObject, NSCoding {

    var date: Date?
    var eventName: String?
    var personName: String?
    var isComplete: Bool?
    var incompleteCount: Int?
    
    func initWithData(date: Date,
                      eventName: String,
                      personName: String,
                      isComplete: Bool,
                      incompleteCount: Int) {
        self.date = date
        self.eventName = eventName
        self.personName = personName
        self.isComplete = isComplete
        self.incompleteCount = incompleteCount
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let date = aDecoder.decodeObject(forKey: "date") as? Date,
        let eventName = aDecoder.decodeObject(forKey: "eventName") as? String,
        let personName = aDecoder.decodeObject(forKey: "personName") as? String,
        let isComplete = aDecoder.decodeObject(forKey: "isComplete") as? Bool,
        let incompleteCount = aDecoder.decodeObject(forKey: "incompleteCount") as? Int
            else {
              return nil
        }
        self.init()
        self.initWithData(date: date, eventName: eventName, personName: personName, isComplete: isComplete, incompleteCount: incompleteCount)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: "date")
        coder.encode(self.eventName, forKey: "eventName")
        coder.encode(self.personName, forKey: "personName")
        coder.encode(self.isComplete, forKey: "isComplete")
        coder.encode(self.incompleteCount, forKey: "incompleteCount")
    }
}
