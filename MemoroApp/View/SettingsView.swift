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
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    Toggle(SettingsView.localAuthToggleText, isOn: $localAuthEnabled)
                } header: {
                    Text(SettingsView.securitySectionHeaderText)
                } footer: {
                    Text(SettingsView.securitySectionFooterText)
                }
                
            }
            .navigationTitle(SettingsView.viewTitleText)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    static let viewTitleText = LocalizedStringKey("SettingsView.Settings")
    static let securitySectionHeaderText = LocalizedStringKey("SettingsView.Security")
    static let securitySectionFooterText = LocalizedStringKey("SettingsView.securitySectionFooter")
    static let localAuthToggleText = LocalizedStringKey("SettingsView.Local Authentication")
}
