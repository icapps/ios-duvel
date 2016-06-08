//
//  NSManagedObjectContext+Create.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
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