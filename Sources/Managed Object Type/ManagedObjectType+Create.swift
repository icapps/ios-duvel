//
//  ManagedObjectType+Create.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

/// Extends some extra create functionality to `NSManagedObject`.
public extension ManagedObjectType {
    
    /// Create a `NSManagedObject` in the given context.
    /// 
    /// ```
    /// let object = SomeManagedObject.create(in: context)
    /// ```
    ///
    /// You are able to immediatly update the properties if you apply them on the given object returned by the attributes callback.
    ///
    /// ```
    /// let object = SomeManagedObject.create(in: context) { innerObject in
    ///     innerObject.name = "Some name"
    /// }
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to create the object.
    /// - Parameter attributes: This is a callback with the created object on which you want to change some properties.
    public static func create(in context: NSManagedObjectContext, attributes: ((_ object: Self) -> ())? = nil) -> Self {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Self else {
            fatalError("Entity \(entityName) does not correspond to \(self)")
        }
        attributes?(object)
        return object
    }
    
}
