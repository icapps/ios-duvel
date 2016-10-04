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
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Stella" }
                    
                    let predicate = NSPredicate(format: "name = %@", "l")
                    Beer.deleteAll(in: duvel.mainContext, with: predicate)
                    expect(Beer.count(in: duvel.mainContext)).to(equal(2))
                }
                
                it("should delete one object") {
                    let beer: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Duvel" }
                    expect(Beer.count(in: duvel.mainContext)).to(equal(1))
                    
                    beer.delete(in: duvel.mainContext)
                    expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                }
                
                it("should delete all objects") {
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Stella" }
                    
                    Beer.deleteAll(in: duvel.mainContext)
                    expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                }
                
                it("should delete all objects from the predicate") {
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Stella" }
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Vedette" }
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", "l")
                    Beer.deleteAll(in: duvel.mainContext, with: predicate)
                    expect(Beer.count(in: duvel.mainContext)).to(equal(1))
                }
            }
        }
        
    }
}
