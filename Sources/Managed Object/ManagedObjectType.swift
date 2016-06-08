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
    
    public static var entityName: String {
        return String(self).componentsSeparatedByString(".").last!
    }
    
    public static func fetchRequest(withPredicate predicate: NSPredicate? = nil, withSortDescriptors descriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = descriptors
        return request
    }
    
}