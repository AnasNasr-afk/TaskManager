//
//  AddTaskView.swift
//  Task5
//
//  Created by Anas Nasr on 21/08/2025.
//
import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What would you like to accomplish?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    TextField("Enter task title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .focused($isTextFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                addTask()
                            }
                        }
                    
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addTask()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private func addTask() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.title = trimmedTitle
            newTask.isCompleted = false
            newTask.createdAt = Date()
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                print("Error saving task: \(error)")
            }
        }
    }
}

#Preview {
    AddTaskView()
}
