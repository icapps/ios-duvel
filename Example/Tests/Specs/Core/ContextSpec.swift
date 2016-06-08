//
//  ContextSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class ContextSpec: QuickSpec {
    override func spec() {
        
        describe("managed object context") {
            var duvel: Duvel!
            beforeEach { duvel = try! Duvel(storeType: NSInMemoryStoreType) }
            
            it("should be able to create a main context.") {
                expect(duvel.mainContext).toNot(beNil())
                expect(duvel.mainContext.concurrencyType).to(equal(NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType))
            }
            
            it("should be able to create a background context.") {
                expect(duvel.backgroundContext).toNot(beNil())
                expect(duvel.backgroundContext.concurrencyType).to(equal(NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType))
            }
            
            it("should be able to have a current context on the main thread.") {
                var useMainContext = false
                dispatch_async(dispatch_get_main_queue()) {
                    useMainContext = duvel.currentContext == duvel.mainContext
                }
                expect(useMainContext).toEventually(beTrue())
            }
            
            it("should be able to have a current context on the background thread.") {
                var useBackgroundContext = false
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    useBackgroundContext = duvel.currentContext == duvel.backgroundContext
                }
                expect(useBackgroundContext).toEventually(beTrue())
            }
        }
        
    }
}
