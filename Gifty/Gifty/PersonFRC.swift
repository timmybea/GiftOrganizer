//
//  PersonFRC.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData

class PersonFRC: NSObject {

    static let frc: NSFetchedResultsController<Person>? = {
        guard let moc = moc else { return nil }
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "group", cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }()
    
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
