//
//  TabNavigationView.swift
//  NotAPlaceApp
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
    @AppStorage("ShowWelcomeNotice") var showWelcomeNotice: Bool = true
    
    var body: some View {
        
        ZStack {
            
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
            
            if showWelcomeNotice {
                WelcomeNotice(showWelcomeNotice: $showWelcomeNotice)
            }
            
        }
        
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
            .environmentObject(LocalAuthManager())
            .environmentObject(PlaceManager())
    }
}

extension TabNavigationView {
    static let mapViewLabelText = LocalizedStringKey("TabNavigationView.World Map")
    static let placesLabelText = LocalizedStringKey("TabNavigationView.Places")
    static let settingsLabelText = LocalizedStringKey("TabNavigationView.Settings")
}
