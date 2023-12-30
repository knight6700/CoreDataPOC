# Core Data Proof of Concept (POC) inProgress

This is a simple Proof of Concept (POC) demonstrating basic operations using Core Data in Swift in my Example More generic.

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Getting Started](#getting-started)
4. [Usage](#usage)
    - [Fetch](#fetch)
    - [Add](#add)
    - [Delete](#delete)
    - [Relationships](#relationships)
5. [License](#license)

## Introduction

This Core Data POC provides a foundation for working with Core Data in Swift. It covers basic operations such as fetching, adding, deleting entities, and managing relationships.

## Features

- **Fetch:** Retrieve data from Core Data.
- **Add:** Add new entities to Core Data.
- **Delete:** Remove entities from Core Data.
- **Relationships:** Demonstrate how to manage relationships between entities.

## Getting Started

To get started with this Core Data POC, follow these steps:

1. Clone the repository.
2. Open the Xcode project (`CoreDataPOC.xcodeproj`) in Xcode.
3. Build and run the project on a simulator or a physical device.

## Usage

### Fetch

To retrieve data from Core Data:

```swift
// Example fetch request
let events = try? CoreDataHelper.shared.fetchEvents()

// Use the fetched data as needed
```

### Add

To add a new entity to Core Data:

```swift
// Example adding a new event
let newEvent = Event(context: CoreDataHelper.shared.viewContext)
newEvent.name = "Sample Event"
newEvent.date = Date()

// Save the changes
try? CoreDataHelper.shared.saveContext()
```

### Delete

To delete an entity from Core Data:

```swift
// Example deleting an event
if let eventToDelete = events.first {
    CoreDataHelper.shared.viewContext.delete(eventToDelete)

    // Save the changes
    try? CoreDataHelper.shared.saveContext()
}
```

### Relationships

To manage relationships between entities:

```swift
// Example creating a relationship between Event and Location
let newEvent = Event(context: CoreDataHelper.shared.viewContext)
newEvent.name = "Sample Event"
newEvent.date = Date()

let newLocation = Location(context: CoreDataHelper.shared.viewContext)
newLocation.name = "Sample Location"

// Set the relationship
newEvent.location = newLocation

// Save the changes
try? CoreDataHelper.shared.saveContext()
```

Adjust the examples based on your data model and requirements.

## License

This Core Data POC is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code as needed.
