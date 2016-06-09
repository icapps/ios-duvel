//
//  ManagedObjectType+Context.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

/// Extends some extra fetch functionality to `ManagedObjectType`.
public extension ManagedObjectType {

    /// Convert the `NSManagedObject` to the given `NSManagedObjectContext`.
    ///
    /// - Parameter context: The `NSManagedObjectContext` instance you want to the object convert to.
    public func to(context context: NSManagedObjectContext) -> Self? {
        guard let object = self as? NSManagedObject else {
            fatalError("\(self) isn't a NSManagedObject")
        }
        
        if object.objectID.temporaryID {
            do {
                try object.managedObjectContext?.obtainPermanentIDsForObjects([object])
            } catch {
                return nil
            }
        }
        
        let objectInContext = try? context.existingObjectWithID(object.objectID)
        return objectInContext as? Self
    }
    
}