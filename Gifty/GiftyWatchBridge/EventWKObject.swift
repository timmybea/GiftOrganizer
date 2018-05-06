//
//  EventWKObject.swift
//  GiftyWatchBridge
//
//  Created by Tim Beals on 2018-04-29.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

public class EventWKObject: NSObject, NSCoding {

    public var date: Date
    public var eventName: String
    public var personName: String
    public var incompleteCount: Int
    
    public init(date: Date,
                 eventName: String,
                 personName: String,
                 incompleteCount: Int) {
        self.date = date
        self.eventName = eventName
        self.personName = personName
        self.incompleteCount = incompleteCount
        super.init()
    }
    
    public override var description: String {
        return "\(self.eventName) for \(self.personName)"
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let incompleteCount = Int(aDecoder.decodeCInt(forKey: "incompleteCount"))
        guard let date = aDecoder.decodeObject(forKey: "date") as? Date,
        let eventName = aDecoder.decodeObject(forKey: "eventName") as? String,
        let personName = aDecoder.decodeObject(forKey: "personName") as? String
            else {
              return nil
        }
        self.init(date: date, eventName: eventName, personName: personName, incompleteCount: incompleteCount)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: "date")
        coder.encode(self.eventName, forKey: "eventName")
        coder.encode(self.personName, forKey: "personName")
        coder.encodeCInt(Int32(self.incompleteCount), forKey: "incompleteCount")
    }
}
