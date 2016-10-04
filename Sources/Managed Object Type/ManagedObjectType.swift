//
//  NSManagedObject+Duvel.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 08/06/16.
//
//

import CoreData

public protocol ManagedObjectType: AnyObject {
    
    static var entityName: String { get }
    
}

extension NSManagedObject: ManagedObjectType {
    
    /// The entity name that is by default the class name without the module name.
    open class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
}
