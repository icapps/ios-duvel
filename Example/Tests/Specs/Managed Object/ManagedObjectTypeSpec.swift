//
//  ManagedObjectTypeSpec.swift
//  Duvel
//
//  Created by Jelle Vandebeeck on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Duvel

class ManagedObjectTypeSpec: QuickSpec {
    override func spec() {
        
        describe("managed object type") {
            context("entity naming") {
                it("should have the correct default entity name") {
                    expect(Beer.entityName).to(equal("Beer"))
                }
                
                it("should have the correct overwritten entity name") {
                    expect(Cocktail.entityName).to(equal("LongDrink"))
                }
            }
        }
        
    }
}
