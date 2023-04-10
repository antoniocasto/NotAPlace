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
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            WorldMapView()
                .tabItem {
                    Label(TabNavigationView.mapViewLabelText, systemImage: "map")
                }
                .tag(TabSelectable.map)
            
            SlideshowView()
                .tabItem {
                    Label(TabNavigationView.placesLabelText, systemImage: "house")
                }
                .tag(TabSelectable.places)
            
            SettingsView()
                .tabItem {
                    Label(TabNavigationView.settingsLabelText, systemImage: "gear")
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

extension TabNavigationView {
    static let mapViewLabelText = LocalizedStringKey("TabNavigationView.World Map")
    static let placesLabelText = LocalizedStringKey("TabNavigationView.Places")
    static let settingsLabelText = LocalizedStringKey("TabNavigationView.Settings")
}
