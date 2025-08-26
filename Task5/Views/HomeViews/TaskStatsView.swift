//
//  TaskStatsView.swift
//  Task5
//
//  Created by Anas Nasr on 21/08/2025.
//
import SwiftUI

struct TaskStatsView: View {
    let totalTasks: Int
    let completedTasks: Int
    
    private var completionPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Tasks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(totalTasks)")
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(completedTasks)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                }
            }
            
            if totalTasks > 0 {
                VStack(spacing: 8) {
                    ProgressView(value: completionPercentage)
                        .tint(.green)
                    
                    Text("\(Int(completionPercentage * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
