//
//  NSManagedObjectContext+Fetch.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
    public func first<T: NSManagedObject where T: ManagedObjectType>(
        with attribute: String,
        and value: AnyObject,
        createIfNeeded createIfNeeded: Bool = false
    ) -> T? {
        let predicate = NSPredicate(format: "%K = %@", argumentArray: [attribute, value])
        if let object: T = first(withPredicate: predicate) {
            return object
        }
        
        // When we do not set the createIfNeeded to true, we should not create
        // the object.
        guard createIfNeeded else {
            return nil
        }
        
        // Create the object.
        return create() { object in
            object.setValuesForKeysWithDictionary([attribute: value])
        } as T
    }
    
    public func first<T: NSManagedObject where T: ManagedObjectType>(
        withPredicate predicate: NSPredicate? = nil,
        withSortDescriptors descriptors: [NSSortDescriptor]? = nil
    ) -> T? {
        let request = T.fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        request.fetchLimit = 1
        return execute(fetchRequest: request).first as? T
    }
    
    public func all<T: NSManagedObject where T: ManagedObjectType>(
        withPredicate predicate: NSPredicate? = nil,
        withSortDescriptors descriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let request = T.fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        return execute(fetchRequest: request) as! [T]
    }
    
    // MARK: - Fetch request
    
    private func execute(fetchRequest request: NSFetchRequest) -> [NSManagedObject] {
        var fetchedObjects = [NSManagedObject]()
        performBlockAndWait {
            do {
                if let managedObjects = try self.executeFetchRequest(request) as? [NSManagedObject] {
                    fetchedObjects = managedObjects
                }
            } catch {
                print(error)
            }
        }
        return fetchedObjects
    }
    
}