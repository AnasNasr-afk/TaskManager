//
//  SettingsView.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("Notifications Demo") { NotficationDemoView() }
                }
                Section {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Text("Dark Mode")
                    }
                    .onChange(of: viewModel.isDarkMode) { value in
                        viewModel.toggleDarkMode(value)
                    }
                    Toggle(isOn: $viewModel.enableNotifications) {
                        Text("Enable Notifications")
                    }
                    .onChange(of: viewModel.enableNotifications) { value in
                        viewModel.toggleNotifications(value)
                    }
                }
            }
            .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
            .navigationTitle("Settings")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Settings Updated"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }



}
