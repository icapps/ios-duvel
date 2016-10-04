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
        if Thread.isMainThread {
            return mainContext
        } else {
            return backgroundContext
        }
    }
    
}

extension NSManagedObjectContext {
    
    internal func createChildContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = self
        return childContext
    }
    
}
