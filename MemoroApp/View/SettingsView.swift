//
//  SettingsView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI

struct SettingsView: View {
    
    // Persistent setting
    @AppStorage("LocalAuthEnabled") private var localAuthEnabled = false
    
    let viewTitleText = "Settings"
    let securitySectionHeaderText = "Security"
    let securitySectionFooterText = "Local Authentication uses device biometric authentication or the device code to hide the places you have saved in Memoro from anyone but you."
    let localAuthToggleText = "Local Authentication"
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    Toggle(localAuthToggleText, isOn: $localAuthEnabled)
                } header: {
                    Text(securitySectionHeaderText)
                } footer: {
                    Text(securitySectionFooterText)
                }
                
            }
            .navigationTitle(viewTitleText)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
