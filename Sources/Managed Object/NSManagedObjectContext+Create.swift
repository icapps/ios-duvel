//
//  NSManagedObjectContext+Create.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
    /// Create the `NSManagedObject` in the current context.
    /// 
    /// ```
    /// let object: SomeManagedObject = yourContext.create()
    /// ```
    ///
    /// You are able to immediatly update the properties if you apply them on the given object returned by the attributes callback.
    ///
    /// ```
    /// let object: SomeManagedObject = yourContext.create() { innerObject in
    ///     innerObject.name = "Some name"
    /// }
    /// ```
    ///
    /// - Parameter attributes: This is a callback with the created object on which you want to change some properties.
    public func create<T: NSManagedObject where T: ManagedObjectType>(
        attributes: ((object: T) -> ())? = nil
    ) -> T {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName, inManagedObjectContext: self) as? T else {
            fatalError("Entity \(T.entityName) does not correspond to \(T.self)")
        }
        attributes?(object: object)
        return object
    }
    
}