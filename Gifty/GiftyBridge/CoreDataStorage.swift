//
//  CoreDataStorage.swift
//  Gifty
//
//  Created by Tim Beals on 2018-01-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import CoreData

public protocol DataPersistence {
    func saveToContext(_ context: NSManagedObjectContext?, completion: (() -> Void)?)
    var mainQueueContext: NSManagedObjectContext? { get }
    var privateQueueContext: NSManagedObjectContext? { get }
}

//PROTOCOL METHODS NEED TO BE STATIC BECAUSE YOU CAN NOT PASS AN INSTANCE ACROSS DIFFERENT TARGETS. INSTEAD INSTANTIATE IT IN THE BRIDGE AND ACCESS IT'S FUNCTIONALITY THROUGH STATIC METHODS AND PROPERTIES.

public class CoreDataStorage: NSObject, DataPersistence {
    
    // MARK: - Shared Instance
    private struct Static {
        fileprivate static var instance: CoreDataStorage?
    }
    
    public static var shared: CoreDataStorage {
        if Static.instance == nil {
            Static.instance = CoreDataStorage()
            
            NotificationCenter.default.addObserver(Static.instance!, selector: #selector(contextDidSavePrivateQueueContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.shared.privateQueueContext)
            
            NotificationCenter.default.addObserver(Static.instance!, selector: #selector(contextDidSaveMainQueueContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.shared.mainQueueContext)
        }
        return Static.instance!
    }
    
    // MARK: - Initialization
    private override init() { }
    
    deinit {
        Static.instance = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Notifications
    @objc func contextDidSavePrivateQueueContext(_ notification: Notification) {
        if let context = self.mainQueueCtxt {
            self.synced(self, closure: { () -> () in
                context.perform({() -> Void in
                    context.mergeChanges(fromContextDidSave: notification)
                })
            })
        }
    }
    
    @objc func contextDidSaveMainQueueContext(_ notification: Notification) {
        if let context = self.privateQueueCtxt {
            self.synced(self, closure: { () -> () in
                context.perform({() -> Void in
                    context.mergeChanges(fromContextDidSave: notification)
                })
            })
        }
    }
    
    func synced(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        return Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let frameworkBundle = Bundle(identifier: "com.roobicreative.GiftyBridge") else {
            fatalError("Error finding Bundle for bridge")
        }
        guard let modelURL = frameworkBundle.url(forResource: "PersonEventModel", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from \(modelURL)")
        }
        return mom
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.roobicreative.gifty")!
        let url = directory.appendingPathComponent("Gifty.sqlite")
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch var error as NSError {
            coordinator = nil
            NSLog("Unresolved error \(error), \(error.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        return coordinator
    }()
    
    // MARK: - NSManagedObject Contexts
    
    lazy private var mainQueueCtxt: NSManagedObjectContext? = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    public var mainQueueContext: NSManagedObjectContext? {
        return self.mainQueueCtxt
    }
    
    lazy private var privateQueueCtxt: NSManagedObjectContext? = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    public var privateQueueContext: NSManagedObjectContext? {
        return self.privateQueueCtxt
    }

    // MARK: - Core Data Saving support
    private func privateSaveContext(_ context: NSManagedObjectContext?, completion: () -> ()) {
        guard let moc = context else { print("CoreDataService: could not get moc"); return }
        if moc.hasChanges {
            do {
                try moc.save()
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    open func saveToContext(_ context: NSManagedObjectContext?, completion: (() -> ())?) {
        self.privateSaveContext(context) {
            completion?()
        }
    }
}
extension NSManagedObject {
    
    public class func findAllForEntity(_ entityName: String, context: NSManagedObjectContext) -> [AnyObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let result: [AnyObject]?
        do {
            result = try context.fetch(request)
        } catch let error as NSError {
            print(error)
            result = nil
        }
        return result
    }
}
