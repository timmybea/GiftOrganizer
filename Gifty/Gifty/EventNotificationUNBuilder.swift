//
//  EventNotificationUNBuilder.swift
//  UNNotifications+CoreData
//
//  Created by Tim Beals on 2018-02-10.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import UserNotifications
import GiftyBridge


protocol EventNotificationUN {
    func createUNNotification(eventNotification: EventNotification)
    func removeUNNotification(id: String)
}

class EventNotificationUNService: NSObject, EventNotificationUN {
    
    private let unCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()

        getAuthorization()
    }
    
    private func getAuthorization() {
        
        let options = UNAuthorizationOptions([.alert, .sound, .badge])
        unCenter.requestAuthorization(options: options) { (success, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if success {
                self.unCenter.delegate = self
                self.createActionsCategories()
            }
        }
    }

    private func createActionsCategories() {
        //action, category
        let action = UNNotificationAction(identifier: NotificationModel.event.actionId,
                                          title: "DEFAULT TEXT",
                                          options: [.foreground])
        
        let category = UNNotificationCategory(identifier: NotificationModel.event.categoryId,
                                              actions: [action],
                                              intentIdentifiers: [])
        
        unCenter.setNotificationCategories([category])
    }
    
    //protocol method
    func createUNNotification(eventNotification: EventNotification) {
        
        guard let title = eventNotification.eventTitle, let body = eventNotification.message, let date = eventNotification.date, let id = eventNotification.id else { return }
        
        guard let fullName = eventNotification.event?.person?.fullName,
            let type = eventNotification.event?.type else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "\(fullName) • \(type)"
        content.subtitle = title
        content.body = body
        content.sound = .default()
        content.categoryIdentifier = NotificationModel.event.categoryId
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        unCenter.add(request, withCompletionHandler: nil)
    }
    
    func removeUNNotification(id: String) {
        unCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension EventNotificationUNService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
    }
}
