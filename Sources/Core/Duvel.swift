//
//  Duvel.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public class Duvel {
    
    // MARK: - Private
    
    private var managedObjectModel: NSManagedObjectModel?
    
    // MARK: - Context
    
    public let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    public let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    // MARK: - Init
    
    public static var sharedInstance: Duvel? = {
        return try? Duvel()
    }()
    
    public init(storeURL: NSURL = Duvel.defaultStoreURL, storeType: String = NSSQLiteStoreType) throws {
        // Set default model found in the main bundle.
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        // Create the persisten store coordinator.
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        try persistentStoreCoordinator?.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: nil)
        
        // Assign the coordinator to the contexts.
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Start the Core Data notifications.
        startReceivingContextNotifications()
    }
    
    // MARK: - Destroy
    
    public func destroyStore(storeURL: NSURL = Duvel.defaultStoreURL) throws {
        // Stop the Core Data notifications.
        stopReceivingContextNotifications()
        
        // Reset context
        mainContext.reset()
        backgroundContext.reset()
        
        // Remove persistent store.
        if let store = persistentStoreCoordinator?.persistentStoreForURL(storeURL) {
            try persistentStoreCoordinator?.removePersistentStore(store)
            try NSFileManager.defaultManager().removeItemAtURL(storeURL)
        }
        
        // reset coordinator and model
        persistentStoreCoordinator = nil
        managedObjectModel = nil
    }
    
    // MARK: - Store
    
    public private(set) var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    private static var bundleIdentifier: String {
        if let identififer = NSBundle.mainBundle().bundleIdentifier {
            return identififer
        }
        return NSBundle(forClass: Duvel.self).bundleIdentifier!
    }
    
    private static var defaultStoreURL: NSURL {
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(defaultSearchPath, inDomains: .UserDomainMask).last!
        let storeName = "\(bundleIdentifier).sqlite"
        return directoryURL.URLByAppendingPathComponent(storeName)
    }
    
    private static var defaultSearchPath: NSSearchPathDirectory {
        #if os(tvOS)
            return .CachesDirectory
        #else
            return .DocumentDirectory
        #endif
    }
    
}

extension Duvel {
    
    // MARK: - Notifications
    
    private func startReceivingContextNotifications() {
        let center = NSNotificationCenter.defaultCenter()
        
        // Context Sync
        center.addObserver(self, selector: #selector(Duvel.didSaveContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: mainContext)
        center.addObserver(self, selector: #selector(Duvel.didSaveContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
    }
    
    private func stopReceivingContextNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Context Sync
    
    @objc func didSaveContext(notification: NSNotification) {
        if let context = notification.object as? NSManagedObjectContext {
            let contextToRefresh = context == mainContext ? backgroundContext : mainContext
            mergeChangesFromNotification(notification, inContext: contextToRefresh)
        }
    }
    
    // MARK: - Merge changes
    
    private func mergeChangesFromNotification(notification: NSNotification, inContext context: NSManagedObjectContext) {
        context.performBlock({ () -> Void in
            context.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
}