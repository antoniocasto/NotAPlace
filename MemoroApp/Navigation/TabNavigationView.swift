//
//  TabNavigationView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI

struct TabNavigationView: View {
    
    enum TabSelectable: String, Hashable {
        case map = "Map"
        case places = "Places"
        case settings = "Settings"
    }
    
    @AppStorage("SelectedTab") var selectedTab: TabSelectable = .places
    
    let mapViewLabelText = "World Map"
    let placesLabelText = "Places"
    let settingsLabelText = "Settings"
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            Text("Map View")
                .tabItem {
                    Label(mapViewLabelText, systemImage: "map")
                }
                .tag(TabSelectable.map)
            
            Text("Places")
                .tabItem {
                    Label(placesLabelText, systemImage: "house")
                }
                .tag(TabSelectable.places)
            
            SettingsView()
                .tabItem {
                    Label(settingsLabelText, systemImage: "gear")
                }
                .tag(TabSelectable.settings)
            
        }
        
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
