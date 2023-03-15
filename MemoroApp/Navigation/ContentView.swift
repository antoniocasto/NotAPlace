//
//  ContentView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 09/03/23.
//

import SwiftUI

struct ContentView: View {
    
    // Manager for Local Authentication
    @EnvironmentObject var localAuthManager: LocalAuthManager
    
    // Persistent setting
    @AppStorage("LocalAuthEnabled") private var localAuthEnabled = false
    
    var body: some View {
        
        if localAuthEnabled {
            
            // Local Auth is enabled.
            // If user is not authenticated, force local auth.
            if localAuthManager.isAuthenticated {
                
                TabNavigationView()
                
            } else {
                
                LocalAuthView()
                
            }
            
        } else {
            
            // Local Auth is disabled.
            TabNavigationView()
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocalAuthManager())
    }
}
