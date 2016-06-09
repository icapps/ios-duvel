//
//  Cocktail.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import CoreData
import Duvel

class Cocktail: NSManagedObject {
    
    @NSManaged var name: String
    
    // MARK: - ManagedObjectType
    
    override class var entityName: String {
        return "LongDrink"
    }
    
}