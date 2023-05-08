//
//  NotAPlaceApp.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 09/03/23.
//

import SwiftUI

@main
struct NotAPlaceAppApp: App {
        
    // Manager for Local Authentication
    @StateObject var localAuthManager = LocalAuthManager()
    
    // Manager for saved places
    @StateObject var placeManager = PlaceManager()
    
    // Persistent settings
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localAuthManager)
                .environmentObject(placeManager)
                .tint(themePreference.accentColor)
                .preferredColorScheme(themePreference.themeScheme)
        }
    }
}