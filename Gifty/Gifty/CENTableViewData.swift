//
//  CreateEventTVData.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

struct CENTableViewData {
    
    static func getData() -> [CENCellType] {
        return [.date, .title, .body]
    }
}

enum CENCellType {
    case title
    case body
    case date
}
