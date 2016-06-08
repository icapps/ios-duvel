//
//  NSManagedObjectSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class NSManagedObjectSpec: QuickSpec {
    override func spec() {
        // Create the managed object model from the test bundle.
        let bundle = NSBundle(forClass: NSManagedObjectSpec.self)
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([bundle])
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("create") {
                it("should create an entity") {
                    let beer: Beer = duvel.mainContext.create()
                    expect(beer.self).to(equal(beer))
                }
                
                it("should create an entity and set it's properties") {
                    let beer: Beer = duvel.mainContext.create() { beer in
                        beer.name = "Duvel"
                    }
                    expect(beer.name).to(equal("Duvel"))
                }
            }
        }
        
    }
}
