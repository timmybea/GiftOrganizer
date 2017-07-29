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
            frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "date", cacheName: nil)
  
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
}

