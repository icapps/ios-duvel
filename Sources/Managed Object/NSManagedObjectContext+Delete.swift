//
//  NSManagedObjectContext+Delete.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
    /// Delete all the `NSManagedObject` in the current context.
    ///
    /// ```
    /// deleteAll(SomeManagedObject.self)
    /// ```
    ///
    /// You can filter which ones to delete depending on the given predicate.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// deleteAll(SomeManagedObject.self, withPredicate: predicate)
    /// ```
    ///
    /// - Parameter type: The `NSMangedObject` type you want to delete.
    /// - Parameter prediate: You can filter by giving a predicate.
    public func deleteAll<T: NSManagedObject where T: ManagedObjectType>(
        type: T.Type,
        withPredicate predicate: NSPredicate? = nil
    ) {
        let objects: [T] = all(withPredicate: predicate)
        for object in objects {
            deleteObject(object)
        }
    }
    
}