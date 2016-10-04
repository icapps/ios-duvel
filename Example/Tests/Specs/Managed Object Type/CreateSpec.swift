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
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: self.managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("create") {
                it("should create an entity") {
                    let beer: Beer = Beer.create(in: duvel.mainContext)
                    expect(beer.self).to(equal(beer))
                }
                
                it("should create an entity and set it's properties") {
                    let beer: Beer = Beer.create(in: duvel.mainContext) { beer in
                        beer.name = "Duvel"
                    }
                    expect(beer.name).to(equal("Duvel"))
                }
            }
            
            context("find or create") {
                it("should create an entity") {
                    let beer: Beer? = Beer.first(in: duvel.mainContext, with: "name", and: "Vedett", createIfNeeded: true)
                    expect(beer?.name).to(equal("Vedett"))
                }
                
                it("should not create a found entity") {
                    let _: Beer = Beer.create(in: duvel.mainContext) { $0.name = "Vedett" }
                    let beer: Beer? = Beer.first(in: duvel.mainContext)
                    expect(beer?.name).to(equal("Vedett"))
                    
                    let anotherBeer: Beer? = Beer.first(in: duvel.mainContext, with: "name", and: "Vedett")
                    expect(beer).to(equal(anotherBeer))
                }
                
                it("should not create an entity that was not found") {
                    let beer: Beer? = Beer.first(in: duvel.mainContext, with: "name", and: "Vedett")
                    expect(beer).to(beNil())
                    
                    let beers: [Beer] = Beer.all(in: duvel.mainContext)
                    expect(beers.count).to(equal(0))
                }
            }
        }
        
    }
}
