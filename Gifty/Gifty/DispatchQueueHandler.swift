//
//  DispatchHandler.swift
//  Gifty
//
//  Created by Tim Beals on 2018-01-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

enum DispatchQueueHandler {
    
    case notification
    
    var queue: DispatchQueue {
        switch self {
        case .notification:
            return DispatchQueue(label: "notificationQueue", qos: DispatchQoS.userInitiated)
        }
    }
    
    
    
}

