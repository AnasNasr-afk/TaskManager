//
//  SettingsView.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//


import SwiftUI
import CoreData

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @ObservedObject private var appSettings: AppSettings
    
    // State for delete confirmation
    @State private var showDeleteConfirmation = false

    init(context: NSManagedObjectContext, appSettings: AppSettings) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(context: context))
        self.appSettings = appSettings
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Dark Mode", isOn: Binding(
                        get: { appSettings.isDarkMode },
                        set: { newValue in
                            appSettings.isDarkMode = newValue
                            viewModel.toggleDarkMode(newValue)
                        }
                    ))

                    Toggle("Enable Notifications", isOn: Binding(
                        get: { viewModel.enableNotifications },
                        set: { viewModel.toggleNotifications($0) }
                    ))
                }

                Section(header: Text("App Management")) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete All Tasks")
                    }

                    Button("Reset Permissions Guide") {
                        viewModel.resetPermissions()
                    }
                    .foregroundColor(.orange)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                viewModel.isDarkMode = appSettings.isDarkMode
            }
            .alert("Permission Guide", isPresented: $viewModel.showPermissionAlert) {
                Button("Open Settings") {
                    viewModel.openAppSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("To reset permissions:\n\n1. Go to iOS Settings\n2. Find 'Pin & Plan' in the app list\n3. Tap on it to modify permissions\n\nOr reset all app permissions:\nSettings > General > Reset > Reset Location & Privacy")
            }
            .alert("Info", isPresented: $viewModel.showAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .destructive) {
                    viewModel.deleteAllTasks()
                }
              
            } message: {
                Text("Do you really want to delete all tasks? This action cannot be undone.")
            }
        }
    }
}
