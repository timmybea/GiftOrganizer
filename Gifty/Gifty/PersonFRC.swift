//
//  PersonFRC.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge
import CoreData

class PersonFRC: NSObject {
    
    static func frc(byGroup bool: Bool) -> NSFetchedResultsController<Person>? {
        
        //guard let moc = moc else { return nil }
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let frc: NSFetchedResultsController<Person>?
        
        if bool {
            let groupDescriptor = NSSortDescriptor(key: "group", ascending: true)
            let nameDescriptor = NSSortDescriptor(key: "alphabetisedName", ascending: true)
            fetchRequest.sortDescriptors = [groupDescriptor, nameDescriptor]
            frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "group", cacheName: nil)
        } else {
            let groupDescriptor = NSSortDescriptor(key: "alphabetisedSection", ascending: true)
            let nameDescriptor = NSSortDescriptor(key: "alphabetisedName", ascending: true)
            fetchRequest.sortDescriptors = [groupDescriptor, nameDescriptor]
            frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "alphabetisedSection", cacheName: nil)
        }
        do {
            try frc?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }
    
    private static let moc = CoreDataStorage.mainQueueContext()
    
    static func updateMoc() {
        //guard let moc = moc else { return }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func person(with name: String) -> Person? {
        let predicate = NSPredicate(format: "fullName == %@", name)
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = predicate
        
        var person: Person?
        
        //guard let moc = moc else { return nil }
        
        do {
            person = try moc.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return person!
    }
}
