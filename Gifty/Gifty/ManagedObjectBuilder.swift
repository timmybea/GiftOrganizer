//
//  ManagedObjectBuilder.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectBuilder: NSObject {

    static let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    //MARK: PERSON MODEL
    static func createPerson(firstName: String, lastName: String?, group: String, profileImage: UIImage?, completion: (_ success: Bool, _ person: Person?) -> Void) {
    
        guard let moc = moc else {
            completion(false, nil)
            return
        }
        
        let person = Person(context: moc)
        person.id = UUID().uuidString
        
        setPersonVariables(person: person, firstName: firstName, lastName: lastName, group: group, profileImage: profileImage) { (success, person) in
            
            if success {
                completion(true, person)
            } else {
                completion(false, nil)
            }
        }
    }
    
    static func updatePerson(person: Person, firstName: String, lastName: String?, group: String, profileImage: UIImage?, completion: (_ success: Bool, _ person: Person?) -> Void) {
        
        setPersonVariables(person: person, firstName: firstName, lastName: lastName, group: group, profileImage: profileImage) { (success, person) in
            if success {
                completion(true, person)
            } else {
                completion(false, nil)
            }
        }
    }
    
    private static func setPersonVariables(person: Person, firstName: String, lastName: String?, group: String, profileImage: UIImage?, completion: (_ success: Bool, _ person: Person?) -> Void) {
        
        person.firstName = firstName
        
        if let lastName = lastName {
            person.lastName = lastName
            person.alphabetisedName = lastName
            person.fullName = "\(firstName) \(lastName)"
        } else {
            person.alphabetisedName = firstName
            person.fullName = firstName
        }
        
        let upperCase = person.alphabetisedName?.uppercased()
        if let character = upperCase?.first {
            let string: String = "\(character)"
            person.alphabetisedSection = string
        }
        
        person.group = group
        
        if let image = profileImage {
            person.profileImage = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        }
        completion(true, person)
    }
    
    private func getUpperCasedCharFromString(string: String) -> Character {
        let upperCase = string.uppercased()
        let first = upperCase.first
        return first!
    }
    
    //MARK: EVENT MODEL
    static func addNewEventToPerson(date: Date, type: String, gift: ActionButton.SelectionStates, card: ActionButton.SelectionStates, phone: ActionButton.SelectionStates, person: Person, budgetAmt: Float, completion: (_ success: Bool, _ event: Event?) -> Void) {
        
        guard let moc = moc else {
            completion(false, nil)
            return
        }
        
        let event = Event(context: moc)
        event.id = UUID().uuidString
        event.date = date
        event.dateString = DateHandler.stringFromDate(date)
        event.type = type
        event.giftState = gift.rawValue
        event.cardState = card.rawValue
        event.phoneState = phone.rawValue
        event.budgetAmt = budgetAmt
        
        _ = setEventComplete(event)
        
        person.addToEvent(event)
        
        completion(true, event)
    }
    
    static func setEventComplete(_ event: Event) -> Bool {
        if event.giftState == ActionButton.SelectionStates.selected.rawValue || event.cardState == ActionButton.SelectionStates.selected.rawValue || event.phoneState == ActionButton.SelectionStates.selected.rawValue {
            event.isComplete = false
        } else {
            event.isComplete = true
        }
        return event.isComplete
    }
    
    static func getEventBy(uuid: String) -> Event? {
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let predicate = NSPredicate(format: "id CONTAINS[c] '\(uuid)'")
        fetchRequest.predicate = predicate

        var fetchedEvents: [Event]?
        
        do {
            fetchedEvents = try moc?.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return fetchedEvents?.first
    }


    
    //MARK: SAVE
    static func saveChanges(completion: (_ success: Bool) -> Void) {
        guard let moc = moc else {
            completion(false)
            return
        }
        
        do {
            try moc.save()
            completion(true)
        } catch {
            completion(false)
            print(error.localizedDescription)
        }
    }

    //MARK: Development tools
    static func printAllPeople() {
        
    }
    
    static func deleteAllPeople() {
        guard let people = PersonFRC.frc(byGroup: true)?.fetchedObjects as [Person]? else { return }
        
        for person in people {
            
            for event in person.event?.allObjects as! [Event] {
                event.managedObjectContext?.delete(event)
            }
            person.managedObjectContext?.delete(person)
        }
        PersonFRC.updateMoc()
    }
    
    static func deleteAllEvents() {
        guard let events = EventFRC.frc()?.fetchedObjects as [Event]? else { return }
        
        for event in events {
            
                event.managedObjectContext?.delete(event)
        }
        PersonFRC.updateMoc()
    }
}
