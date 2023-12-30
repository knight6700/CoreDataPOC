//
//  CoreDataManager.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import CoreData

public class CoreDataManager {
    public static let shared = CoreDataManager()

    private let coreDataStack = CoreDataStack.shared

    public func fetch<T: NSManagedObject>(_ entityClass: T.Type) async throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
        /*
         NSFetchRequest
         can take a Query paramters with NSPredicate formate
         can make a limit fetch
         */
        return try await withCheckedThrowingContinuation { continuation in
            do {
                continuation.resume(returning: try coreDataStack.mainContext.fetch(fetchRequest))
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func save() {
        coreDataStack.saveContext()
    }

    public func delete<T: NSManagedObject>(_ entityClass: T.Type, id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.persistentContainer.performBackgroundTask { context in
                do {
                    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: entityClass))
                    fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                    
                    let objects = try context.fetch(fetchRequest)

                    for object in objects {
                        context.delete(object)
                    }
                    try context.save()
                    // Perform any additional actions or notify if needed
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: StorageError.unExpecterror(error.localizedDescription))
                }
            }
        }
    }
    public func deleteAllPosts<T: NSManagedObject>(_ entityClass: T.Type) {
        let context = coreDataStack.mainContext

        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: entityClass))

        do {
            let posts = try context.fetch(fetchRequest)

            for post in posts {
                context.delete(post)
            }

            try context.save() // Save the context to persist the changes
        } catch {
        }
    }

    public func saveElement<T: NSManagedObject>(_ element: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.persistentContainer.performBackgroundTask { backgroundContext in
                backgroundContext.performAndWait {
                    do {
                        var newElement: T
                        newElement = T(context: backgroundContext)
                        
                        
                        if let dic = element.toDictionary() {
                            for (key, _) in dic {
                                newElement.setValue(element.value(forKey: key), forKey: key)
                            }
                            if let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: backgroundContext) {
                                for property in entityDescription.properties {
                                    let propertyName = property.name
                                    
                                    if let value = element.value(forKey: propertyName) {
                                        if let relationshipDescription = property as? NSRelationshipDescription {
                                            // Handle relationships
                                            if relationshipDescription.isToMany {
                                                // To-Many relationship
                                                if let set = value as? NSSet {
                                                    let newSet = NSMutableSet()
                                                    for case let relatedObject as NSManagedObject in set {
                                                        // Make sure the related object is in the same context
                                                        let newRelatedObject = backgroundContext.object(with: relatedObject.objectID) ?? relatedObject
                                                        newSet.add(newRelatedObject)
                                                    }
                                                    newElement.setValue(newSet, forKey: propertyName)
                                                }
                                            } else {
                                                // To-One relationship
                                                var relation: Place = Place(context: backgroundContext)
                                                guard let element = element as? Events,
                                                let dic = element.place.toDictionary() else {
                                                    return
                                                }
                                                if let relatedObject = value as? NSManagedObject {
                                                    let newRelatedObject = backgroundContext.object(with: relatedObject.objectID)
                                                    if let dic = newRelatedObject.toDictionary() {
                                                        for (key, _) in  dic {
                                                            relation.setValue(element.place.value(forKey: key), forKey: key)
                                                        }
                                                        newElement.setValue(relation, forKey: propertyName)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        backgroundContext.insert(newElement)
                        try backgroundContext.save()
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: StorageError.unExpecterror(error.localizedDescription))
                    }
                }
            }
        }
    }
    public func saveArrayToCoreData<T: NSManagedObject>(_ array: [T]) {
        let context = coreDataStack.mainContext

        for item in array {
            context.insert(item)
        }

        do {
            try context.save() // Save the context to persist the changes
        } catch {
            debugPrint("Error saving array to Core Data: \(error)")
        }
    }
}
