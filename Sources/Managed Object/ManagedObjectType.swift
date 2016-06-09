//
//  NSManagedObject+Duvel.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public protocol ManagedObjectType {
    
    static var entityName: String { get }
    
}

extension ManagedObjectType {
    
    /// The entity name that is by default the class name without the module name.
    public static var entityName: String {
        return String(self).componentsSeparatedByString(".").last!
    }
    
    /// Returns a fetch request with the given predicate and sort descriptors.
    ///
    /// - Parameter predicate: The `NSPredicate` you want to use to filter the request.
    /// - Parameter descriptots: The array of `NSSortDescriptor` you want to use to sort the request.
    public static func fetchRequest(withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = descriptors
        return request
    }
    
}