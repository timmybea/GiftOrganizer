//
//  EventFRC.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-29.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData

class EventFRC: NSObject {
    
    static func frc() -> NSFetchedResultsController<Event>? {
        
        guard let moc = moc else { return nil }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let frc: NSFetchedResultsController<Event>?
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        //let personNameDescriptor = NSSortDescriptor(key: "person.fullname", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dateString", cacheName: nil)
  
        do {
            try frc?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }
    
    
    static func frc(for date: Date) -> NSFetchedResultsController<Event>? {
        
        guard let moc = moc else { return nil }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let frc: NSFetchedResultsController<Event>?
        
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]

        let dateString = DateHandler.stringFromDate(date)
        let predicate = NSPredicate(format: "dateString CONTAINS[c] '\(dateString)'")
        fetchRequest.predicate = predicate
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dateString", cacheName: nil)
        
        do {
            try frc?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }
    
    private static let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static func updateMoc() {
        guard let moc = moc else { return }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func sortEventsIntoUpcomingAndOverdue(events: [Event], sectionHeaders: Bool, completion: (_ upcomingEvents: [TableSectionEvent], _ overdueEvents: [TableSectionEvent]) -> ()) {
        
        var overdue: [TableSectionEvent] = [TableSectionEvent(header: nil, events: [Event]())]
        
        var upcoming: [TableSectionEvent]
        if sectionHeaders {
            upcoming = [TableSectionEvent(header: "This Week", events: [Event]()),
                         TableSectionEvent(header: "This Month", events: [Event]()),
                         TableSectionEvent(header: "Later", events: [Event]())]
        } else {
            upcoming = [TableSectionEvent(header: nil, events: [Event]())]
        }
        
        let now = DateHandler.localTimeFromUTC(Date())
        let todayString = DateHandler.stringFromDate(now)
        guard let today = DateHandler.dateFromDateString(todayString) else { completion(upcoming, overdue); return }
    
        for event in events {
            guard let eventDate = event.date as Date? else { continue }
            if eventDate < today {
                if !event.isComplete {
                    overdue[0].events.append(event)
                }
            } else {
                if sectionHeaders {
                    if DateHandler.sameComponent(.weekOfYear, date1: eventDate, date2: today) {
                        upcoming[0].events.append(event)
                    } else if DateHandler.sameComponent(.month, date1: eventDate, date2: today) {
                        upcoming[1].events.append(event)
                    } else {
                        upcoming[2].events.append(event)
                    }
                } else {
                    upcoming[0].events.append(event)
                }
            }
        }
        upcoming = upcoming.filter() { $0.events.count > 0 }
        completion(upcoming, overdue)
    }
}

struct TableSectionEvent {
    let header: String?
    var events: [Event]
}

