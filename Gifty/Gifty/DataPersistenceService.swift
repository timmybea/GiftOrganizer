//
//  DataPersistenceService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge
import CoreData


//Use dependency injection instead of adding the CoreDataStorage singleton to your project

class DataPersistenceService: DataPersistence {
    
    func saveToContext(_ context: NSManagedObjectContext?) {
        self.dataPersistence.saveToContext(context)
    }
    
    var mainQueueContext: NSManagedObjectContext? {
        return self.dataPersistence.mainQueueContext
    }
    
    var privateQueueContext: NSManagedObjectContext? {
        return self.dataPersistence.privateQueueContext
    }
    
    
    private var dataPersistence: DataPersistence
    
    private init() {
        self.dataPersistence = CoreDataStorage.shared
    }
    
    private struct Static {
        static var instance: DataPersistenceService?
    }
    
    static var shared: DataPersistenceService {
        if Static.instance == nil {
            Static.instance = DataPersistenceService()
        }
        return Static.instance!
    }
}
