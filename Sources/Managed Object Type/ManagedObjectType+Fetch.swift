//
//  ManagedObjectType+Fetch.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

/// Extends some extra fetch functionality to `ManagedObjectType`.
public extension ManagedObjectType {
    
    /// Returns a fetch request with the given predicate and sort descriptors.
    ///
    /// - Parameter predicate: The `NSPredicate` you want to use to filter the request.
    /// - Parameter descriptors: The array of `NSSortDescriptor` you want to use to sort the request.
    public static func fetchRequest(withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = descriptors
        return request
    }
    
    /// Fetch the first `NSManagedObject` where the attribute has a certain value.
    /// 
    /// ```
    /// let object = SomeManagedObject.first(inContext: context, with: "name", value: "Leroy")
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the object.
    /// - Parameter attribute: The object attribute you want to check.
    /// - Parameter value: The object attribute's value you want to check.
    /// - Parameter createIfNeeded: Create the object with the attribute's value if not found.
    public static func first(inContext context: NSManagedObjectContext, with attribute: String, and value: AnyObject, createIfNeeded: Bool = false) -> Self? {
        let predicate = NSPredicate(format: "%K = %@", argumentArray: [attribute, value])
        if let object = first(inContext: context, withPredicate: predicate) {
            return object
        }
        
        // When we do not set the createIfNeeded to true, we should not create
        // the object.
        guard createIfNeeded else {
            return nil
        }
        
        // Create the object.
        var object: Self? = nil
        if let createdObject = create(inContext: context) as? NSManagedObject {
            createdObject.setValuesForKeysWithDictionary([attribute: value])
            object = createdObject as? Self
        }

        return object
    }
    
    /// Fetch the first `NSManagedObject` that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let object = SomeManagedObject.first(inContext: context, withPredicate: predicate, withSortDescriptors: descriptors)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the object.
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public static func first(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> Self? {
        let request = fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        request.fetchLimit = 1
        return execute(fetchRequest: request, inContext: context).first
    }
    
    /// Fetch all `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let objects = SomeManagedObject.all(inContext: context, withPredicate: predicate, withSortDescriptors: descriptors)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the objects.
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public static func all(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> [Self] {
        let request = fetchRequest(withPredicate: predicate, withSortDescriptors: descriptors)
        return execute(fetchRequest: request, inContext: context)
    }
    
    /// Count the number of `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let count = SomeManagedObject.count(inContext: context, withPredicate: predicate)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to count the objects.
    /// - Parameter predicate: The predicate used for filtering.
    public static func count(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil) -> Int {
        let request = fetchRequest(withPredicate: predicate)
        request.includesSubentities = false
        return context.countForFetchRequest(request, error: nil)
    }
    
    // MARK: - Fetch request
    
    private static func execute(fetchRequest request: NSFetchRequest, inContext context: NSManagedObjectContext) -> [Self] {
        var fetchedObjects = [Self]()
        context.performBlockAndWait {
            do {
                if let managedObjects = try context.executeFetchRequest(request) as? [Self] {
                    fetchedObjects = managedObjects
                }
            } catch {
                print(error)
            }
        }
        return fetchedObjects
    }
    
}