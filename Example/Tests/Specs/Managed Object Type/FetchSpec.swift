//
//  FetchSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class FetchSpec: QuickSpec {
    override func spec() {
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: self.managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("fetch request") {
                it("should create a fetch request") {
                    let request = Beer.fetchRequest()
                    expect(request).toNot(beNil())
                    expect(request.entityName).to(equal("Beer"))
                }
            }
            
            context("first") {
                it("should not find a first object") {
                    let beer: Beer? = Beer.first(inContext: duvel.mainContext)
                    expect(beer).to(beNil())
                }
                
                it("should find a first object") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    
                    let beer: Beer? = Beer.first(inContext: duvel.mainContext)
                    expect(beer).toNot(beNil())
                }
                
                it("should find a first object with attribute") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    
                    let beer: Beer? = Beer.first(inContext: duvel.mainContext, with: "name", and: "Duvel")
                    expect(beer).toNot(beNil())
                    expect(beer?.name).to(equal("Duvel"))
                }
                
                it("should find a first object depending on the predicate") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let predicate = NSPredicate(format: "name = %@", "Stella")
                    let beer: Beer? = Beer.first(inContext: duvel.mainContext, withPredicate: predicate)
                    expect(beer?.name).to(equal("Stella"))
                }
                
                it("should find a first object depending on the sort descriptor") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let descriptor = NSSortDescriptor(key: "name", ascending: false)
                    let beer: Beer? = Beer.first(inContext: duvel.mainContext, withSortDescriptors: [descriptor])
                    expect(beer?.name).to(equal("Stella"))
                }
            }
            
            context("all") {
                it("should not find any object") {
                    let beers: [Beer] = Beer.all(inContext: duvel.mainContext)
                    expect(beers.count).to(equal(0))
                }
                
                it("should find two objects") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let beers: [Beer] = Beer.all(inContext: duvel.mainContext)
                    expect(beers.count).to(equal(2))
                }
                
                it("should find two objects depending on the predicate") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Vedett" }
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", "l")
                    let beers: [Beer] = Beer.all(inContext: duvel.mainContext, withPredicate: predicate)
                    expect(beers.count).to(equal(2))
                }
                
                it("should find two objects sorted with the sort descriptor") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    let descriptor = NSSortDescriptor(key: "name", ascending: false)
                    let beers: [Beer] = Beer.all(inContext: duvel.mainContext, withSortDescriptors: [descriptor])
                    expect(beers.first?.name).to(equal("Stella"))
                    expect(beers.last?.name).to(equal("Duvel"))
                }
            }
            
            context("count") {
                it("should not count any object") {
                    expect(Beer.count(inContext: duvel.mainContext)).to(equal(0))
                }
                
                it("should find two objects") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    
                    expect(Beer.count(inContext: duvel.mainContext)).to(equal(2))
                }
                
                it("should find two objects depending on the predicate") {
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Stella" }
                    let _: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Vedett" }
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", "l")
                    expect(Beer.count(inContext: duvel.mainContext, withPredicate: predicate)).to(equal(2))
                }
            }
            
            context("convert to context") {
                it("should be able to convert an object to a context") {
                    let beer: Beer = Beer.create(inContext: duvel.mainContext) { $0.name = "Duvel" }
                    
                    var completed = false
                    duvel.mainContext.perform(changes: { context in
                        let beerInContext = beer.to(context: context)
                        expect(beer.managedObjectContext).toNot(equal(context))
                        expect(beerInContext?.managedObjectContext).to(equal(context))
                    }, completion: {
                        completed = true
                    })
                    
                    expect(completed).toEventually(beTrue())
                }
            }
        }
        
    }
}
