//
//  NotificationModel.swift
//  UNNotifications+CoreData
//
//  Created by Tim Beals on 2018-02-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

enum NotificationModel {
    
    case event
    
    var actionId: String {
        switch self {
        case .event: return "NotificationModel.event.actionId"
        }
    }
    
    var categoryId: String {
        switch self {
        case .event: return "NotificationModel.event.categoryId"
        }
    }
}
