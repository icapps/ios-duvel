//
//  Duvel.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

/// `Duvel` is responsible for creating the persistent stores and creating the contexts we want to use.
open class Duvel {
    
    // MARK: - Private
    
    fileprivate var managedObjectModel: NSManagedObjectModel?
    
    // MARK: - Context
    
    /// This is the `NSManagedObjectContext` you can use on the main thread. This context is a `MainQueueConcurrencyType`.
    open let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    /// This is the `NSManagedObjectContext` you can use on the background thread. This context is a `PrivateQueueConcurrencyType`.
    open let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    // MARK: - Init
    
    /// Initalize `Duvel` and create a managed object model and a persistent store coordinate with a linked store.
    ///
    /// Next to this it will create a main managed object context and one for use in the background.
    ///
    /// - Parameter managedObjectModel: Pass the optional managed object model just in case it already exists.
    /// - Parameter storeURL: Pass the optional store url just in case it already exists.
    /// - Parameter storeType: Pass the optional store type. The default type is `NSSQLiteStoreType`.
    public init(managedObjectModel: NSManagedObjectModel? = NSManagedObjectModel.mergedModel(from: nil), storeURL: URL = Duvel.defaultStoreURL, storeType: String = NSSQLiteStoreType) throws {
        // Create the persisten store coordinator.
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        try persistentStoreCoordinator?.addPersistentStore(ofType: storeType, configurationName: nil, at: storeURL, options: nil)
        
        // Assign the coordinator to the contexts.
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Start the Core Data notifications.
        startReceivingContextNotifications()
    }
    
    deinit {
        stopReceivingContextNotifications()
    }
    
    // MARK: - Destroy
    
    /// You can destroy your persisten store and it's linked contexts.
    ///
    /// - Parameter storeURL: Pass the optional store url just in case it is custom defined.
    open func destroyStore(_ storeURL: URL = Duvel.defaultStoreURL) throws {
        // Stop the Core Data notifications.
        stopReceivingContextNotifications()
        
        // Reset context
        mainContext.reset()
        backgroundContext.reset()
        
        // Remove persistent store.
        if let store = persistentStoreCoordinator?.persistentStore(for: storeURL) {
            try persistentStoreCoordinator?.remove(store)
            try FileManager.default.removeItem(at: storeURL)
        }
        
        // reset coordinator and model
        persistentStoreCoordinator = nil
        managedObjectModel = nil
    }
    
    // MARK: - Store
    
    /// The `NSPersistentStoreCoordinator` that is set to `Duvel`.
    open fileprivate(set) var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    fileprivate static var bundleIdentifier: String {
        if let identififer = Bundle.main.bundleIdentifier {
            return identififer
        }
        return Bundle(for: Duvel.self).bundleIdentifier!
    }
    
    fileprivate static var defaultStoreURL: URL {
        let directoryURL = FileManager.default.urls(for: defaultSearchPath, in: .userDomainMask).last!
        let storeName = "\(bundleIdentifier).sqlite"
        return directoryURL.appendingPathComponent(storeName)
    }
    
    fileprivate static var defaultSearchPath: FileManager.SearchPathDirectory {
        #if os(tvOS)
            return .CachesDirectory
        #else
            return .documentDirectory
        #endif
    }
    
}

extension Duvel {
    
    // MARK: - Notifications
    
    fileprivate func startReceivingContextNotifications() {
        let center = NotificationCenter.default
        
        // Context Sync
        center.addObserver(self, selector: #selector(Duvel.didSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: mainContext)
        center.addObserver(self, selector: #selector(Duvel.didSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
    }
    
    fileprivate func stopReceivingContextNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Context Sync
    
    @objc func didSaveContext(_ notification: Notification) {
        if let context = notification.object as? NSManagedObjectContext {
            let contextToRefresh = context == mainContext ? backgroundContext : mainContext
            mergeChangesFromNotification(notification, in: contextToRefresh)
        }
    }
    
    // MARK: - Merge changes
    
    fileprivate func mergeChangesFromNotification(_ notification: Notification, in context: NSManagedObjectContext) {
        context.perform({ () -> Void in
            context.mergeChanges(fromContextDidSave: notification)
        })
    }
    
}
