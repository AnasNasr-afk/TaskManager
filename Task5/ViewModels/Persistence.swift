//
//  Persistence.swift
//  Task5
//
//  Created by Anas Nasr on 20/08/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // Preview without dummy data
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        // No dummy tasks — just an empty context
        try? context.save()
        return controller
    }()

    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Task5")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
