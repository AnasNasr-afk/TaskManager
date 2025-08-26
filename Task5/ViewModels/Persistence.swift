//
//  Persistence.swift
//  Task5
//
//  Created by Anas Nasr on 20/08/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        let sampleTask1 = Task(context: context)
        sampleTask1.title = "Complete iOS Bootcamp Task"
        sampleTask1.isCompleted = false
        sampleTask1.createdAt = Date()
        
        let sampleTask2 = Task(context: context)
        sampleTask2.title = "Learn SwiftUI"
        sampleTask2.isCompleted = true
        sampleTask2.createdAt = Date().addingTimeInterval(-86400) // Yesterday
        
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
