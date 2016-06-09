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
    /// SomeManagedObject.deleteAll(inContext: context, withPredicate: predicate)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to delete the objects.
    /// - Parameter prediate: You can filter by giving a predicate.
    public static func deleteAll(
        inContext context: NSManagedObjectContext,
        withPredicate predicate: NSPredicate? = nil
    ) {
        let objects = all(inContext: context, withPredicate: predicate)
        for object in objects {
            object.delete(inContext: context)
        }
    }
    
    // TODO: Add tests.
    public func delete(
        inContext context: NSManagedObjectContext
    ) {
        guard let object = self as? NSManagedObject else {
            fatalError("\(self) isn't a NSManagedObject")
        }
        context.deleteObject(object)
    }
    
}