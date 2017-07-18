//
//  ManagedObjectBuilder.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

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
        
        var upperCase = person.alphabetisedName?.uppercased()
        if let character = upperCase?.characters.popFirst() {
            let string: String = "\(character)"
            person.alphabetisedSection = string
        }
        
        person.group = group
        
        if let image = profileImage {
            person.profileImage = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        }
        completion(true, person)
    }
    
    private func getUpperCasedCharFromString(string: String) -> Character {
        var upperCase = string.uppercased()
        let first = upperCase.characters.popFirst()
        return first!
    }
    
    //MARK: EVENT MODEL
    static func addNewEventToPerson(date: Date, type: String, gift: ActionsSelectionState, card: ActionsSelectionState, phone: ActionsSelectionState, person: Person, completion: (_ success: Bool, _ event: Event?) -> Void) {
        
        guard let moc = moc else {
            completion(false, nil)
            return
        }
        
        let event = Event(context: moc)
        event.id = UUID().uuidString
        event.date = date as NSDate
        event.type = type
        event.giftState = gift.rawValue
        event.cardState = card.rawValue
        event.phoneState = phone.rawValue
        
        person.addToEvent(event)
        
        completion(true, event)
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
            person.managedObjectContext?.delete(person)
        }
        PersonFRC.updateMoc()
    }

}
