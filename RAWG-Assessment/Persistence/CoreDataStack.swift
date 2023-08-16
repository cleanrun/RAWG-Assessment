//
//  CoreDataStack.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import Foundation
import CoreData

final class CoreDataStack {
    private let modelName: String = "GameStack"
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                print("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = storeContainer.viewContext
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
}
