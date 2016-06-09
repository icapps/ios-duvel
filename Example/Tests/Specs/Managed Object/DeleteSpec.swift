//
//  DeleteSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class DeleteSpec: QuickSpec {
    override func spec() {
        // Create the managed object model from the test bundle.
        let bundle = NSBundle(forClass: DeleteSpec.self)
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([bundle])
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("delete") {
                it("should not delete any object") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let predicate = NSPredicate(format: "name = %@", "l")
                    duvel.mainContext.deleteAll(Beer.self, withPredicate: predicate)
                    expect(duvel.mainContext.count(Beer.self)).to(equal(2))
                }
                
                it("should delete all objects") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    duvel.mainContext.deleteAll(Beer.self)
                    expect(duvel.mainContext.count(Beer.self)).to(equal(0))
                }
                
                it("should delete all objects from the predicate") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Vedette" }
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", "l")
                    duvel.mainContext.deleteAll(Beer.self, withPredicate: predicate)
                    expect(duvel.mainContext.count(Beer.self)).to(equal(1))
                }
            }
        }
        
    }
}
