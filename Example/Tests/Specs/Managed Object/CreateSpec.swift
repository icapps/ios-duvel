//
//  CreateSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class CreateSpec: QuickSpec {
    override func spec() {
        // Create the managed object model from the test bundle.
        let bundle = NSBundle(forClass: CreateSpec.self)
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
            
            context("find or create") {
                it("should create an entity") {
                    let beer: Beer? = duvel.mainContext.first(with: "name", and: "Vedett", createIfNeeded: true)
                    expect(beer?.name).to(equal("Vedett"))
                }
                
                it("should not create a found entity") {
                    let _: Beer = duvel.mainContext.create() { $0.name = "Vedett" }
                    let beer: Beer? = duvel.mainContext.first()
                    expect(beer?.name).to(equal("Vedett"))
                    
                    let anotherBeer: Beer? = duvel.mainContext.first(with: "name", and: "Vedett")
                    expect(beer).to(equal(anotherBeer))
                }
                
                it("should not create an entity that was not found") {
                    let beer: Beer? = duvel.mainContext.first(with: "name", and: "Vedett")
                    expect(beer).to(beNil())
                    
                    let beers: [Beer] = duvel.mainContext.all()
                    expect(beers.count).to(equal(0))
                }
            }
        }
        
    }
}
