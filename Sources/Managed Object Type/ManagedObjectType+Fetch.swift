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
    public static func fetchRequest(with predicate: NSPredicate?, sort descriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = descriptors
        return request
    }
    
    /// Fetch the first `NSManagedObject` where the attribute has a certain value.
    /// 
    /// ```
    /// let object = SomeManagedObject.first(in: context, with: "name", value: "Leroy")
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the object.
    /// - Parameter attribute: The object attribute you want to check.
    /// - Parameter value: The object attribute's value you want to check.
    /// - Parameter createIfNeeded: Create the object with the attribute's value if not found.
    public static func first(in context: NSManagedObjectContext, with attribute: String, and value: Any, createIfNeeded: Bool = false) -> Self? {
        let predicate = NSPredicate(format: "%K = %@", argumentArray: [attribute, value])
        if let object = first(in: context, with: predicate) {
            return object
        }
        
        // When we do not set the createIfNeeded to true, we should not create
        // the object.
        guard createIfNeeded else {
            return nil
        }
        
        // Create the object.
        var object: Self? = nil
        if let createdObject = create(in: context) as? NSManagedObject {
            createdObject.setValuesForKeys([attribute: value])
            object = createdObject as? Self
        }

        return object
    }
    
    /// Fetch the first `NSManagedObject` that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let object = SomeManagedObject.first(in: context, with: predicate, sort: descriptors)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the object.
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public static func first(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil, sort descriptors: [NSSortDescriptor]? = nil) -> Self? {
        let request = fetchRequest(with: predicate, sort: descriptors)
        request.fetchLimit = 1
        return execute(fetchRequest: request, in: context).first
    }
    
    /// Fetch all `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let descriptors: [NSSortDescriptor] = ...
    /// let objects = SomeManagedObject.all(in: context, with: predicate, sort: descriptors)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to fetch the objects.
    /// - Parameter predicate: The predicate used for filtering.
    /// - Parameter descriptors: The sort descriptors used for sorting the result.
    public static func all(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil, sort descriptors: [NSSortDescriptor]? = nil) -> [Self] {
        let request = fetchRequest(with: predicate, sort: descriptors)
        return execute(fetchRequest: request, in: context)
    }
    
    /// Count the number of `NSManagedObject`'s that matches the predicate and is sorted in a way.
    ///
    /// ```
    /// let predicate: NSPredicate = ...
    /// let count = SomeManagedObject.count(in: context, with: predicate)
    /// ```
    ///
    /// - Parameter context: This is the context in which you want to count the objects.
    /// - Parameter predicate: The predicate used for filtering.
    public static func count(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil) -> Int {
        let request = fetchRequest(with: predicate)
        request.includesSubentities = false
        return (try? context.count(for: request)) ?? 0
    }
    
    // MARK: - Fetch request
    
    private static func execute(fetchRequest request: NSFetchRequest<NSManagedObject>, in context: NSManagedObjectContext) -> [Self] {
        var fetchedObjects = [Self]()
        context.performAndWait {
            do {
                if let managedObjects = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [Self] {
                    fetchedObjects = managedObjects
                }
            } catch {
                print(error)
            }
        }
        return fetchedObjects
    }
    
}
