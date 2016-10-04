//
//  SaveSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class SaveSpec: QuickSpec {
    override func spec() {
        
        describe("managed object") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(managedObjectModel: self.managedObjectModel, storeType: NSInMemoryStoreType) }
            
            context("save") {
                it("should save an entity on the main context") {
                    expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                    
                    var beerCreated = false
                    duvel.mainContext.perform(changes: { context in
                        let _ = Beer.create(in: context)
                        expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                    }, completion: {
                        beerCreated = true
                        expect(Beer.count(in: duvel.mainContext)).to(equal(1))
                    })
                    
                    expect(beerCreated).toEventually(beTrue())
                }
                
                it("should save an entity on the background context") {
                    expect(Beer.count(in: duvel.backgroundContext)).to(equal(0))
                    expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                    
                    var beerCreated = false
                    duvel.backgroundContext.perform(changes: { context in
                        let _ = Beer.create(in: context)
                        expect(Beer.count(in: duvel.backgroundContext)).to(equal(0))
                        expect(Beer.count(in: duvel.mainContext)).to(equal(0))
                    }, completion: {
                        beerCreated = true
                        expect(Beer.count(in: duvel.backgroundContext)).to(equal(1))
                        expect(Beer.count(in: duvel.mainContext)).to(equal(1))
                    })
                    
                    expect(beerCreated).toEventually(beTrue())
                }
            }
        }
        
    }
}
