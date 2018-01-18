//
//  TableSectionEvent.swift
//  Gifty
//
//  Created by Tim Beals on 2018-01-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

public class TableSectionEvent {
    
    public let header: String?
    public var events: [Event]
    
    public init(header: String?, events: [Event]) {
        self.header = header
        self.events = events
    }
}
