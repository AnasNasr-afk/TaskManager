//
//  HomeView.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    @State private var showingAddTask = false
    @Binding var selectedTab: Int
    @Binding var mapCityName: String
    
    // ✅ Add refresh trigger
    @State private var refreshTrigger = false

    private var totalTasks: Int {
        tasks.count
    }
    
    private var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TaskStatsView(
                    totalTasks: totalTasks,
                    completedTasks: completedTasks
                )
                .padding()
            
                if tasks.isEmpty {
                    EmptyStateView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(tasks) { task in
                            TaskRowView(
                                task: task,
                                onToggle: { toggleTask(task) },
                                selectedTab: $selectedTab,
                                mapCityName: $mapCityName
                            )
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .refreshable {
                        // ✅ Add pull-to-refresh functionality
                        refreshTasks()
                    }
                }
            }
            .navigationTitle("Task Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
                    .environment(\.managedObjectContext, viewContext)
            }
            // ✅ Listen for tasks deleted notification
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TasksDeleted"))) { _ in
                refreshTasks()
            }
            // ✅ Refresh when view appears (in case of tab switching)
            .onAppear {
                refreshTasks()
            }
        }
    }
    
    private func toggleTask(_ task: Task) {
        withAnimation {
            task.isCompleted.toggle()
            saveContext()
        }
    }
    
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // ✅ Add refresh function to force UI update
    private func refreshTasks() {
        refreshTrigger.toggle()
        viewContext.refreshAllObjects()
    }
}

#Preview {
    HomeView(selectedTab: .constant(0), mapCityName: .constant(""))
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
