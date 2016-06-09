//
//  Duvel+Context.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

extension Duvel {
    
    /// The current context is the either the main `NSManagedObjectContext` or the background one. This depends on which thread you call the `currentContext` property.
    public var currentContext: NSManagedObjectContext {
        if NSThread.isMainThread() {
            return mainContext
        } else {
            return backgroundContext
        }
    }
    
}

extension NSManagedObjectContext {
    
    public func inContext<T: NSManagedObject where T: ManagedObjectType>(object: T) -> T? {
        if object.objectID.temporaryID {
            do {
                try object.managedObjectContext?.obtainPermanentIDsForObjects([object])
            } catch {
                return nil
            }
        }
        
        let objectInContext = try? existingObjectWithID(object.objectID)
        return objectInContext as? T
    }
    
    internal func childContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childContext.parentContext = self
        return childContext
    }
    
}