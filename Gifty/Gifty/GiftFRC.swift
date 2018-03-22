//
//  GiftFRC.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-22.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import CoreData
import GiftyBridge

class GiftFRC {
    
    static func getGifts(for event: Event) -> [Gift]? {
        guard let eventId = event.id else { return nil }
        let moc = event.managedObjectContext
        let fetchRequest: NSFetchRequest<Gift> = Gift.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let predicate = NSPredicate(format: "%K = %@", "eventId", "\(eventId)")
        fetchRequest.predicate = predicate
        
        do {
            return try moc?.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    
}
