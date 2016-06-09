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
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: self.managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("delete") {
                it("should not delete any object") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let predicate = NSPredicate(format: "name = %@", "l")
                    Beer.deleteAll(inContext: duvel.mainContext, withPredicate: predicate)
                    expect(Beer.count(inContext: duvel.mainContext)).to(equal(2))
                }
                
                it("should delete all objects") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    Beer.deleteAll(inContext: duvel.mainContext)
                    expect(Beer.count(inContext: duvel.mainContext)).to(equal(0))
                }
                
                it("should delete all objects from the predicate") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Vedette" }
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", "l")
                    Beer.deleteAll(inContext: duvel.mainContext, withPredicate: predicate)
                    expect(Beer.count(inContext: duvel.mainContext)).to(equal(1))
                }
            }
        }
        
    }
}
