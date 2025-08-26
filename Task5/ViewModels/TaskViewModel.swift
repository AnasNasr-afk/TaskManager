//
//  TaskViewModel.swift
//  Task5
//
//  Created by Anas Nasr on 21/08/2025.
//

import SwiftUI
import Combine
import CoreData

class TaskViewModel: ObservableObject {
    @Published var taskCount: Int = 0
    @Published var completedTaskCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        setupCoreDataPublisher()
        updateTaskCounts()
    }
    
    private func setupCoreDataPublisher() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateTaskCounts()
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateTaskCounts()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTaskCounts() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let allTasks = try managedObjectContext.fetch(fetchRequest)
            taskCount = allTasks.count
            completedTaskCount = allTasks.filter { $0.isCompleted }.count
        } catch {
            print("Error fetching tasks: \(error)")
            taskCount = 0
            completedTaskCount = 0
        }
    }
    

    func refreshCounts() {
        updateTaskCounts()
    }
}
