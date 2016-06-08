//
//  Cocktail.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import CoreData
import Duvel

final class Cocktail: NSManagedObject {
    
    @NSManaged var name: String
    
}

extension Cocktail: ManagedObjectType {
    
    static var entityName: String {
        return "LongDrink"
    }
    
}