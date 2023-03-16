//
//  SettingsView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI

struct SettingsView: View {
    
    // Persistent settings
    @AppStorage("LocalAuthEnabled") private var localAuthEnabled = false
    @AppStorage("LocalAuthWithBiometrics") private var localAuthWithBiometrics = false
    
    @State private var showPasswordInput = false
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    
                    Toggle(SettingsView.localAuthToggleText, isOn: $localAuthEnabled)
                        .onChange(of: localAuthEnabled) { newValue in
                            if newValue {
                                // If Local Authentication is enabled. A password must be set.
                                showPasswordInput = true
                            }
                        }
                    
                    Toggle(SettingsView.biometricsLocalAuthToggleText, isOn: $localAuthWithBiometrics)
                        .disabled(!localAuthEnabled)
                        
                } header: {
                    Text(SettingsView.securitySectionHeaderText)
                } footer: {
                    Text(SettingsView.securitySectionFooterText)
                }
                
            }
            .alert(SettingsView.passwordAlertTitle, isPresented: $showPasswordInput, actions: {
                SecureField(SettingsView.passwordInput, text: $password)
                SecureField(SettingsView.passwordConfirmInput, text: $passwordConfirm)
                Button(SettingsView.passwordCancelButton, role: .cancel) {
                    // Disable Local Authentication if password is not set.
                    localAuthEnabled = false
                }
                Button(SettingsView.passwordCreateButton) {
                    // Store password securely.
                }
            }, message: {
                Text(SettingsView.passwordAlertMessage)
            })
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
    static let biometricsLocalAuthToggleText = LocalizedStringKey("SettingsView.Use Face ID or Touch ID")
    static let passwordAlertTitle = LocalizedStringKey("SettingsView.Password Requested")
    static let passwordAlertMessage = LocalizedStringKey("SettingsView.PasswordAlertMessage")
    static let passwordCancelButton = LocalizedStringKey("SettingsView.Cancel")
    static let passwordCreateButton = LocalizedStringKey("SettingsView.Create")
    static let passwordInput = LocalizedStringKey("SettingsView.Password")
    static let passwordConfirmInput = LocalizedStringKey("SettingsView.Repeat Password")
}
