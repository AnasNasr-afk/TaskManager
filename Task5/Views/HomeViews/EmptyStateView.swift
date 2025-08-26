//
//  EmptyStateView.swift
//  Task5
//
//  Created by Anas Nasr on 21/08/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
           
            Image(systemName: "checklist")
                .font(.system(size: 80))
                .foregroundColor(.blue.opacity(0.6))
            
           
            VStack(spacing: 8) {
                Text("No Tasks Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Start by adding your first task.\nTap the + button above to get started!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
           
            Image(systemName: "arrow.up.right")
                .font(.title)
                .foregroundColor(.blue.opacity(0.4))
                .offset(x: 20, y: -10)
        }
        .padding()
    }
}


#Preview {
    EmptyStateView()
}

