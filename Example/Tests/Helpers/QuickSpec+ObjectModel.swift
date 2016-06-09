//
//  QuickSpec+ObjectModel.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import CoreData

extension QuickSpec {
    
    var managedObjectModel: NSManagedObjectModel {
        // Create the managed object model from the test bundle.
        let bundle = NSBundle(forClass: CreateSpec.self)
        return NSManagedObjectModel.mergedModelFromBundles([bundle])!
    }
    
}