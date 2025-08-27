//
//  TaskManagerApp.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedTab = 0
    @State private var mapCityName: String = ""

    var body: some Scene {
        WindowGroup {
            //MAINTABVIEW NOT  HOME VIEW 
            HomeView(selectedTab: $selectedTab, mapCityName: $mapCityName)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
