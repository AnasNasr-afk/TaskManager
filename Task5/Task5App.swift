//
//  Task5App.swift
//  Task5
//
//  Created by Anas Nasr on 20/08/2025.
//

import SwiftUI

@main
struct Task5App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
