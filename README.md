# Duvel

[![CI Status](http://img.shields.io/travis/icapps/ios-duvel.svg?style=flat)](https://travis-ci.org/icapps/ios-duvel)
[![License](https://img.shields.io/cocoapods/l/Duvel.svg?style=flat)](http://cocoapods.org/pods/Duvel)
[![Platform](https://img.shields.io/cocoapods/p/Duvel.svg?style=flat)](http://cocoapods.org/pods/Duvel)
[![Version](https://img.shields.io/cocoapods/v/Duvel.svg?style=flat)](http://cocoapods.org/pods/Duvel)
[![Language Swift 2.2](https://img.shields.io/badge/Language-Swift%202.2-orange.svg?style=flat)](https://swift.org)

> Duvel makes using Core Data more friendlier than ever with Swift.

## TOC

- [Installation](#installation)
- [Features](#features)
  - [Initialize](#initialize)
  - [Context](#context)
  - [Creation](#creation)
  - [Deletion](#deletion)
  - [Fetching](#fetching)
  - [Saving](#saving)
- [Bucket List](#bucket-list)
- [Author](#author)
- [License](#license)

## Installation

Duvel is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod 'Duvel', '~> 1.0'
```

## Features

### Initialize

Initialize the usage of `Duvel` by using a `Duvel` instance. When initializing the instance you will create the persistent store.

```swift
// Create the default store.
let duvel = try! Duvel()

// Create an in memory store.
let duvel = try! Duvel(storeType: NSInMemoryStoreType)

// Create a store with a custom managed object model.
let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
let duvel = try! Duvel(managedObjectModel: managedObjectModel)
```

Is you want to instantiate `Duvel` as a `sharedInstance` that you want to use throughout your application without passing the instance between the different classes. Than extend `Duvel` like this.

```swift
extension Duvel {
    static var sharedInstance: Duvel? = {
        // Add more configuration to the instance as shown in the above code.
        return try? Duvel()
    }()
}

// This will encapsulate `Duvel` in an singleton instance.
Duvel.sharedInstance
```

### Context

There are three ways to access some contexts.

```swift
// Get the main `NSManagedObjectContext`.
Duvel.sharedInstance.mainContext

// Get the background `NSManagedObjectContext`.
Duvel.sharedInstance.backgroundContext

// Get the `NSManagedObjectContext` for the current thread.
Duvel.sharedInstance.currentContext
```

Changes made on the `backgroundContext` are automatically merged to the `mainContext` when succeeded.

### Creation

You can create a `NSManagedObject` in a context. The `NSManagedObject` you want to create has to conform to the `ManagedObjectType` protocol. In this case `SomeManagedObject` conforms to `ManagedObjectType`.

```swift
let context: NSManagedObjectContext = ...
let object = SomeManagedObject.create(inContext: context)
```

We can also immediately set the properties during the creation process.

```swift
let context: NSManagedObjectContext = ...
let object = SomeManagedObject.create(inContext: context) { innerObject in
  innerObject.name = "Leroy"
}
```

**BE AWARE!** Nothing is persisted to the store until you save.

### Deletion

There is a possibility to delete all the `NSManagedObject`'s depending on the given `NSPredicate`. When no predicate is given we delete all the objects for the given type.

```swift
let context: NSManagedObjectContext = ...

// Delete all the objects.
SomeManagedObject.deleteAll(inContext: context)

// Delete the objects that match a predicate.
let predicate: NSPredicate = ...
SomeManagedObject.deleteAll(inContext: context, withPredicate: predicate)

// Delete one the object.
let object: SomeManagedObject = ...
object.delete(inContext: context)
```

If you just want to delete a single object, you can use the one defined in Core Data.

```swift
let context: NSManagedObjectContext = ...
SomeManagedObject.deleteObject(inContext: context)
```

**BE AWARE!** Nothing is persisted to the store until you save.

### Fetching

Fetch the first `NSManagedObject` depending on the value of the attribute.

When no object was found for this value, you can create a new one with the attribute set to the given value. This will be done when the `createIfNeeded` parameter is set to true.

```swift
let context: NSManagedObjectContext = ...
let object = SomeManagedObject.first(inContext: context, with: "name", value: "Leroy")
let object = SomeManagedObject.first(inContext: context, with: "name", value: "Leroy", createIfNeeded: true)
```

You can also look for the first `NSManagedObject` found for the given predicate. You can also indicate the sort order of the fetched results so that you can eventually fetch the last object.

```swift
let predicate: NSPredicate = ...
let descriptors: [NSSortDescriptor] = ...
let context: NSManagedObjectContext = ...
let object = SomeManagedObject.first(inContext: context, withPredicate: predicate, withSortDescriptors: descriptors)
```

Fetch all the objects for a certain type. You can specify a filter by giving an `NSPredicate` and a sort order by providing a list of `NSSortDescriptor`'s.

```swift
let predicate: NSPredicate = ...
let descriptors: [NSSortDescriptor] = ...
let context: NSManagedObjectContext = ...
let objects = SomeManagedObject.all(inContext: context, withPredicate: predicate, withSortDescriptors: descriptors)
```

Count the number of object. You can specify a filter by giving an `NSPredicate`.

```swift
let predicate: NSPredicate = ...
let context: NSManagedObjectContext = ...
let count = SomeManagedObject.count(inContext: context, withPredicate: predicate)
```

### Saving

Persist the changes to the store by using the `perform` function provided on the context.

This function will apply the changes to a child context that is created from the initial context. And when these changes are successfully applies they will be merged into the initial context.

```swift
context.perform(changes: { localContext in
  // Modify objects inside this closure. At the end of the closure the changes will be
  // automatically persisted to the store.
  // Make sure you do the changes on the given `localContext`.
}, completion: {
  // This completion closure will be called when `Duvel` finished writing to the store.
})
```

Sometimes you'll want update an existing `NSManagedObject`. If you want to do so and use the `perform` function, than you'll probably need to convert to object to an object from the `localContext`.

```swift
let existingObject: SomeManagedObject = ...
context.perform(changes: { localContext in
  let localObject = existingObject.to(context: localContext)
  localObject.name = "Leroy"
}, completion: {
  ...
})
```

## Bucket List

Here is an overview what is on our todo list.

- [ ] Type safety for attribute creation.
- [ ] Add notifications.

## Author

Jelle Vandebeeck, jelle@fousa.be

## License

Duvel is available under the MIT license. See the LICENSE file for more info.
