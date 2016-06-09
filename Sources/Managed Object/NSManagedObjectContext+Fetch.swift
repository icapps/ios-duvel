//
//  NSManagedObjectContext+Fetch.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public extension NSManagedObjectContext {
    
    /// Fetch the first `NSManagedObject` where the attribute has a certain value.
    /// 
    /// ```
    /// let object: SomeManagedObject? = context.first(with: "name", value: "Leroy")
    /// ```
    ///
    /// - Parameter attribute: The object attribute you want to check.
    /// - Parameter value: The object attribute's value you want to check.
    /// - Parameter createIfNeeded: Create the object with the attribute's value if not found.
    public func first<T: NSManagedObject where T: ManagedObjectType>(
        with attribute: String,
        and value: AnyObject,
        createIfNeeded: Bool = false
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
        return T.create(inContext: self) { object in
            object.setValuesForKeysWithDictionary([attribute: value])
        } as T
    }
    
    /// Fetch the first `NSManagedObject` that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let object: SomeManagedObject? = context.first(withPredicate: predicate, withSortDescriptors: descriptors)
    /// ```
    ///
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public func first<T: NSManagedObject where T: ManagedObjectType>(
        withPredicate predicate: NSPredicate? = nil,
        withSortDescriptors descriptors: [NSSortDescriptor]? = nil
    ) -> T? {
        let request = T.fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        request.fetchLimit = 1
        return execute(fetchRequest: request).first as? T
    }
    
    /// Fetch all `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let objects: [SomeManagedObject] = context.all(withPredicate: predicate, withSortDescriptors: descriptors)
    /// ```
    ///
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public func all<T: NSManagedObject where T: ManagedObjectType>(
        withPredicate predicate: NSPredicate? = nil,
        withSortDescriptors descriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let request = T.fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        return execute(fetchRequest: request) as! [T]
    }
    
    /// Count the number of `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let count = context.count(SomeManagedObject.self, withPredicate: predicate)
    /// ```
    ///
    /// - Parameter type: The `NSManagedObject`'s type you want to count.
    /// - Parameter predicate: The predicate used for filtering.
    public func count<T: NSManagedObject where T: ManagedObjectType>(
        type: T.Type,
        withPredicate predicate: NSPredicate? = nil
    ) -> Int {
        let request = T.fetchRequest(withPredicate: predicate)
        request.includesSubentities = false
        return countForFetchRequest(request, error: nil)
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