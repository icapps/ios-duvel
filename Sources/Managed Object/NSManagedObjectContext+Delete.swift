//
//  NSManagedObjectContext+Delete.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
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