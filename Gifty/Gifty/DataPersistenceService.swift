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


//I cannot access the protocol in the bridgin header, so here it is copied and adopted in an extension.
public protocol DataPersistenceDependency {
    func dpSaveToContext(_ context: NSManagedObjectContext?)
    var dpMainQueueContext: NSManagedObjectContext? { get }
    var dpPrivateQueueContext: NSManagedObjectContext? { get }
}

extension CoreDataStorage: DataPersistenceDependency {
    
    public func dpSaveToContext(_ context: NSManagedObjectContext?) {
        CoreDataStorage.shared.saveToContext(context)
    }
    
    public var dpMainQueueContext: NSManagedObjectContext? {
        return CoreDataStorage.shared.mainQueueContext
    }
    
    public var dpPrivateQueueContext: NSManagedObjectContext? {
        return CoreDataStorage.shared.privateQueueContext
    }
}

//And now here is the wrapper

class DataPersistenceService: DataPersistenceDependency {
    
    private var dataPersistence: DataPersistenceDependency
    
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
    
    func dpSaveToContext(_ context: NSManagedObjectContext?) {
        self.dataPersistence.dpSaveToContext(context)
    }
    
    var dpMainQueueContext: NSManagedObjectContext? {
        return dataPersistence.dpMainQueueContext
    }
    
    var dpPrivateQueueContext: NSManagedObjectContext? {
        return dataPersistence.dpPrivateQueueContext
    }
}
