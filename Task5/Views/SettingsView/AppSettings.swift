//
//  AppSettings.swift
//  Task5
//
//  Created by Anas Nasr on 29/08/2025.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode") {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            print("[DEBUG] Dark mode changed to: \(isDarkMode)")
        }
    }
    
    init() {
        let savedDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.isDarkMode = savedDarkMode
        print("[DEBUG] AppSettings initialized with dark mode: \(savedDarkMode)")
    }
}
