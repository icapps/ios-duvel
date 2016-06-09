//
//  NSManagedObjectContext+Save.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

extension NSManagedObjectContext {
    
    public func perform(changes changes: (context: NSManagedObjectContext) -> (), completion: (() -> ())? = nil) {
        let localContext = childContext()
        localContext.performBlock {
            changes(context: localContext)
            localContext.performSaveIfNeeded()
            
            let parentContext = localContext.parentContext
            parentContext?.performBlock {
                parentContext?.performSaveIfNeeded()
                
                completion?()
            }
        }
    }
    
    private func performSaveIfNeeded() {
        if hasChanges {
            do {
                try save()
            } catch {
                print(error)
            }
        }
    }
    
}