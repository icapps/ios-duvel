//
//  Duvel.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

/// `Duvel` is responsible for creating the persistent stores and creating the contexts we want to use.
///
/// You will be able to use `Duvel` as a singleton (with the `sharedInstance` property) or just as an instance you locate somewhere in your application.
public class Duvel {
    
    // MARK: - Private
    
    private var managedObjectModel: NSManagedObjectModel?
    
    // MARK: - Context
    
    /// This is the `NSManagedObjectContext` you can use on the main thread. This context is a `MainQueueConcurrencyType`.
    public let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    /// This is the `NSManagedObjectContext` you can use on the background thread. This context is a `PrivateQueueConcurrencyType`.
    public let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    // MARK: - Init
    
    /// Use this singlethon property when you are sure you want to use only one `Duvel` instance throughout your entire application.
    public static var sharedInstance: Duvel? = {
        return try? Duvel()
    }()
    
    /// Initalize `Duvel` and create a managed object model and a persistent store coordinate with a linked store.
    ///
    /// Next to this it will create a main managed object context and one for use in the background.
    ///
    /// - Parameter managedObjectModel: Pass the optional managed object model just in case it already exists.
    /// - Parameter storeURL: Pass the optional store url just in case it already exists.
    /// - Parameter storeType: Pass the optional store type. The default type is `NSSQLiteStoreType`.
    public init(managedObjectModel: NSManagedObjectModel? = NSManagedObjectModel.mergedModelFromBundles(nil), storeURL: NSURL = Duvel.defaultStoreURL, storeType: String = NSSQLiteStoreType) throws {
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
    
    /// You can destroy your persisten store and it's linked contexts.
    ///
    /// - Parameter storeURL: Pass the optional store url just in case it is custom defined.
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
    
    /// The `NSPersistentStoreCoordinator` that is set to `Duvel`.
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