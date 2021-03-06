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
    
    private override init() {
        super.init()
    }
    
    static var shared = EventNotificationUNService()
    
    func getAuthorization() {
        
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
        let category = UNNotificationCategory(identifier: NotificationModel.event.categoryId,
                                              actions: [],
                                              intentIdentifiers: [])
        
        unCenter.setNotificationCategories([category])
    }
    
    //protocol method
    func createUNNotification(eventNotification: EventNotification) {
        
        guard let title = eventNotification.title, let body = eventNotification.message, let date = eventNotification.date, let id = eventNotification.id else { return }
        
        guard let fullName = eventNotification.event?.person?.fullName,
            let type = eventNotification.event?.type else { return }
        
        guard let eventDate = eventNotification.event?.date else { return }
        
        let content = UNMutableNotificationContent()
        content.userInfo = ["date" : eventDate]
        content.title = title
        let formattedDate = DateHandler.describeDate(eventDate)
        content.body = "\(body)\n\n\(formattedDate) • \(fullName) • \(type)"
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
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let eventDate = response.notification.request.content.userInfo["date"] as? Date else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.showEvent(for: eventDate)
    }
}
