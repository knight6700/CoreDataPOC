//
//  CoreDataStack.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import CoreData

public class CoreDataStack {
   public static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.main.url(forResource:"Events", withExtension: "momd") else {
            return  NSPersistentContainer(name:"Events")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSPersistentContainer(name:"Events")
        }
        let container = NSPersistentContainer(name:"Events",managedObjectModel:model)

        // Check if running in a test environment
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // Use in-memory store for testing
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("Failed to load Core Data stack: \(error)")
            }
        }

        return container
    }()

    public var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        let saveContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        saveContext.parent = context
        return saveContext
    }

    func saveContext(context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)) {
        context.parent = mainContext
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        context.perform { [weak self] in
            do {
                try self?.mainContext.save()
            } catch {
                debugPrint("Failed to save main context: \(error)")
            }
        }
    }
}



enum StorageError: Error {
    case unExpecterror(String)
}
