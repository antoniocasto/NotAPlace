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
    
    var body: some View {
        
        // If user is not authenticated, force local auth.
        if localAuthManager.isAuthenticated {
            
            TabNavigationView()
            
        } else {
            
            LocalAuthView()
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocalAuthManager())
    }
}
