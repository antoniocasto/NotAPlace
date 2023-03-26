//
//  MemoroAppApp.swift
//  MemoroApp
//
//  Created by Antonio Casto on 09/03/23.
//

import SwiftUI

@main
struct MemoroAppApp: App {
    
    // Manager for Local Authentication
    @StateObject var localAuthManager = LocalAuthManager()
    
    // Manager for saved places
    @StateObject var placeManager = PlaceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localAuthManager)
                .environmentObject(placeManager)
        }
    }
}
