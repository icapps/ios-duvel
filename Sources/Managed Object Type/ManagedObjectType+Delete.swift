//
//  ManagedObjectType+Delete.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

/// Extends some extra delete functionality to `ManagedObjectType`.
public extension ManagedObjectType {
    
    /// Delete all the `NSManagedObject` in the given context.
    ///
    /// ```
    /// SomeManagedObject.deleteAll(inContext: context)
    /// ```
    ///
    /// You can filter which ones to delete depending on the given predicate.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// SomeManagedObject.deleteAll(in: context, with: predicate)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to delete the objects.
    /// - Parameter predicate: You can filter by giving a predicate.
    public static func deleteAll(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil) {
        let objects = all(in: context, with: predicate)
        for object in objects {
            object.delete(in: context)
        }
    }
    
    /// Delete the `NSManagedObject` in the given context.
    ///
    /// ```
    /// SomeManagedObject.delete(in: context)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to delete the objects.
    public func delete(in context: NSManagedObjectContext) {
        guard let object = self as? NSManagedObject else {
            fatalError("\(self) isn't a NSManagedObject")
        }
        context.delete(object)
    }
    
}
