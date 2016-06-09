//
//  NSManagedObjectContext+Save.swift
//  Pods
//
//  Created by Jelle Vandebeeck on 09/06/16.
//
//

import CoreData

extension NSManagedObjectContext {
    
    /// Saves all the changes that are performed in the `changes` block to a local context. And when this was correctly executed these changes are merged with the current `NSManagedObjectContext`.
    ///
    /// ```
    /// context.perform(changes: { localContext in
    ///     ...
    /// }, completion: {
    ///     ...
    /// })
    /// ```
    ///
    /// Be aware that is you want to update an existing object, that you'll have to convert to object to the `localContext`. This can be done with the `inContext` function available in *Duvel*.
    ///
    /// - Parameter changes: The changes closure returns a local context on which you should apply the changes.
    /// - Parameter completion: The completion closure is called when the saving finished.
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