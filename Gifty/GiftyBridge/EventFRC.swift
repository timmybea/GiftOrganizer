//
//  EventFRC.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-29.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData


public class EventFRC: NSObject {
    
    static let dataPersistence: DataPersistence = CoreDataStorage.shared
    
    public static func frc() -> NSFetchedResultsController<Event>? {
        guard let moc = dataPersistence.mainQueueContext else { return nil }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let frc: NSFetchedResultsController<Event>?
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: moc,
                                         sectionNameKeyPath: "dateString", cacheName: nil)
  
        do {
            try frc?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }
    
    public static func getEvent(forId id: String, with context: NSManagedObjectContext) -> Event? {
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let predicate = NSPredicate(format: "%K = %@", "id", id)
        fetchRequest.predicate = predicate
        
        var output: Event? = nil
        do {
            output = try context.fetch(fetchRequest).first
        } catch {
            print("No event found for id \(id)")
        }
        return output
    }
    
    public static func getRecurringEvents(before date: Date) -> [Event]? {
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let predicateRecurring = NSPredicate(format: "%K == %@", "recurringHead", NSNumber(value: true))
        let sortByDate = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = predicateRecurring
        fetchRequest.sortDescriptors = [sortByDate]
        
        var results: [Event]?
        do {
            results = try dataPersistence.mainQueueContext?.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        var output = [Event]()
        
        guard let r = results else { return nil }
        
        for event in r {
            if event.recurring && event.date! < date {
                output.append(event)
            } else {
                break
            }
        }
        return output.count == 0 ? nil : output
    }
    
    
    public static func frc(for date: Date) -> NSFetchedResultsController<Event>? {
        guard let moc = dataPersistence.mainQueueContext else { return nil }
        
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
    
    public static func updateMoc() {
        guard let moc = dataPersistence.mainQueueContext else { return }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public static func sortEventsIntoUpcomingAndOverdue(events: [Event], sectionHeaders: Bool, completion: (_ upcomingEvents: [TableSectionEvent]?, _ overdueEvents: [TableSectionEvent]?) -> ()) {
        
        var overdue: [TableSectionEvent]? = [TableSectionEvent(header: nil, events: [Event]())]
        
        var upcoming: [TableSectionEvent]?
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
                    overdue![0].events.append(event)
                }
            } else {
                if sectionHeaders {
                    
                    if eventDate < Date(timeInterval: 60 * 60 * 24 * 7, since: today) {
                        upcoming![0].events.append(event)
                    } else if DateHandler.sameComponent(.month, date1: eventDate, date2: today) {
                        upcoming![1].events.append(event)
                    } else {
                        upcoming![2].events.append(event)
                    }
                } else {
                    upcoming![0].events.append(event)
                }
            }
        }
        overdue = overdue!.filter() { $0.events.count > 0 }
        upcoming = upcoming!.filter() { $0.events.count > 0 }
        overdue = overdue!.count > 0 ? overdue : nil
        upcoming = upcoming!.count > 0 ? upcoming : nil
        completion(upcoming, overdue)
    }
    
    
    public static func sortEventsTodayExtension(events: [Event], completion: (_ upcomingEvents: [Event]?, _ overdueEvents: [Event]?) -> ()) {
     
        var overdue: [Event]? = [Event]()
        var upcoming: [Event]? = [Event]()

        let now = DateHandler.localTimeFromUTC(Date())
        let todayString = DateHandler.stringFromDate(now)
        guard let today = DateHandler.dateFromDateString(todayString) else { completion(nil, nil); return }

        for event in events {
            guard let eventDate = event.date as Date? else { continue }
            if eventDate < today {
                if !event.isComplete && overdue!.count < 3 {
                    overdue?.append(event)
                }
            } else {
                if upcoming!.count < 3 {
                    upcoming?.append(event)
                }
            }
        }
        overdue = overdue!.isEmpty ? nil : overdue
        upcoming = upcoming!.isEmpty ? nil : upcoming
        
        completion(upcoming, overdue)
    }
}

