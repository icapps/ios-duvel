//
//  SetupSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class SetupSpec: QuickSpec {
    override func spec() {
        
        describe("core data") {
            context("instance") {
                it("should have a persistent store coordinator") {
                    let duvel = try! Duvel()
                    expect(duvel.persistentStoreCoordinator).toNot(beNil())
                }
                
                it("should set a custom store url") {
                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
                    let url = directoryURL.URLByAppendingPathComponent("Data.sqlite")
                    let duvel = try! Duvel(storeURL: url)
                    expect(duvel.persistentStoreCoordinator?.persistentStores.first?.URL).to(equal(url))
                }
                
                it("should set a custom store type") {
                    let duvel = try! Duvel(storeType: NSInMemoryStoreType)
                    expect(duvel.persistentStoreCoordinator?.persistentStores.first?.type).to(equal(NSInMemoryStoreType))
                }
                
                it("should be able to destroy a store") {
                    let duvel = try! Duvel(storeType: NSInMemoryStoreType)
                    expect(duvel.persistentStoreCoordinator?.persistentStores.first).toNot(beNil())
                    
                    try! duvel.destroyStore()
                    expect(duvel.persistentStoreCoordinator?.persistentStores.first).to(beNil())
                }
            }
            
            context("singleton") {
                it("should have a persistent store") {
                    let duvel = Duvel.sharedInstance
                    expect(duvel?.persistentStoreCoordinator).toNot(beNil())
                }
            }
        }
        
    }
}
