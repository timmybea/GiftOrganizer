//
//  ManagedObjectBuilder.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ManagedObjectBuilder: NSObject {

    private static let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static func createPerson(firstName: String, lastName: String, group: String, profileImage: UIImage?, completion: (_ success: Bool, _ person: Person?) -> Void) {
    
        guard let moc = moc else {
            completion(false, nil)
            return
        }
        
        let person = Person(context: moc)
        person.id = UUID().uuidString
        person.firstName = firstName
        person.lastName = lastName
        person.fullName = "\(firstName) \(lastName)"
        person.group = group
                
        if let image = profileImage {
            person.profileImage = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        }
        completion(true, person)
    }

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
        guard let people = PersonFRC.frc?.fetchedObjects as [Person]? else { return }
        
        for person in people {
            person.managedObjectContext?.delete(person)
        }
        PersonFRC.updateMoc()
    }

}
