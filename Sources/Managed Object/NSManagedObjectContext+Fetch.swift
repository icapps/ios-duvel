//
//  NSManagedObjectContext+Fetch.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
    public func first<T: NSManagedObject where T: ManagedObjectType>(withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> T? {
        let request = T.fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        request.fetchLimit = 1
        return execute(fetchRequest: request).first as? T
    }
    
    public func all<T: NSManagedObject where T: ManagedObjectType>(withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> [T] {
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