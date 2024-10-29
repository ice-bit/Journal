//
//  CoreDataStack.swift
//  Journal
//
//  Created by Goutham Das T on 29/10/24.
//

import Foundation
import CoreData

// Define an observable class to encapsulate all Core Data-related functionality.
class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "Journal")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            // Handle the error appropriately. However, it's useful to use
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
}
