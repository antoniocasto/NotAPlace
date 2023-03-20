//
//  SettingsView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI

struct SettingsView: View {
    
    // Manager for Local Authentication
    @EnvironmentObject var localAuthManager: LocalAuthManager
    
    // Persistent settings
    @AppStorage("LocalAuthEnabled") private var localAuthEnabled = false
    @AppStorage("LocalAuthWithBiometrics") private var localAuthWithBiometrics = false
    
    @State private var enableLocalAuth = false
    @State private var enableBiometricAuthToggle = false
    @State private var showPasswordInput = false
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var showPasswordAlert = false
    @State private var passwordAlertMessage = LocalizedStringKey("")
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section {
                    
                    Toggle(SettingsView.localAuthToggleText, isOn: $enableLocalAuth)
                        .onChange(of: enableLocalAuth) { newValue in
                            if newValue {
                                // If Local Authentication is enabled. A password must be set.
                                showPasswordInput = true
                            } else {
                                // Disable Local Auth
                                localAuthEnabled = false
                                localAuthWithBiometrics = false
                            }
                        }
                    
                    // Show only if Local Auth is enabled
                    // and Face ID or Touch ID is available
                    if localAuthEnabled && localAuthManager.canEvaluatePolicy {
                        Toggle(SettingsView.biometricsLocalAuthToggleText, isOn: $enableBiometricAuthToggle)
                            .disabled(!localAuthEnabled)
                            .onChange(of: enableBiometricAuthToggle) { newValue in
                                if newValue {
                                    Task {
                                        await localAuthManager.authenticateWithBiometrics()
                                        localAuthWithBiometrics = localAuthManager.isAuthenticated
                                    }
                                } else {
                                    localAuthWithBiometrics = false
                                }
                            }
                    }
                    
                } header: {
                    Text(SettingsView.securitySectionHeaderText)
                } footer: {
                    Text(SettingsView.securitySectionFooterText)
                }
                
            }
            // Alert for password creation
            .alert(SettingsView.passwordAlertTitle, isPresented: $showPasswordInput, actions: {
                SecureField(SettingsView.passwordInput, text: $password)
                SecureField(SettingsView.passwordConfirmInput, text: $passwordConfirm)
                Button(SettingsView.passwordCancelButton, role: .cancel) {
                    // Disable Local Authentication if password is not set.
                    localAuthEnabled = false
                    enableLocalAuth = false
                }
                Button(SettingsView.passwordCreateButton) {
                    
                    // Store password.
                    // Password validity checks
                    let checkPassed = checkPasswordValidity()
                    
                    // Store password
                    localAuthManager.createPassword(with: password)
                    
                    // Enable Local Password if checks are okay
                    enableLocalAuth = checkPassed
                    localAuthEnabled = checkPassed
                    
                }
            }, message: {
                Text(SettingsView.passwordAlertMessage)
            })
            // Alert for invalid password
            .alert(SettingsView.passwordErrorTitle, isPresented: $showPasswordAlert) {
                Button(SettingsView.passordErrorButton, role: .cancel) {
                    password = ""
                    passwordConfirm = ""
                }
            } message: {
                Text(passwordAlertMessage)
            }
            .navigationTitle(SettingsView.viewTitleText)
        }
        .onAppear {
            enableLocalAuth = localAuthEnabled
            enableBiometricAuthToggle = localAuthWithBiometrics
        }
    }
    
    private func checkPasswordValidity() -> Bool {
        
        if password.count < 8 {
            passwordAlertMessage = SettingsView.passwordErrorMessage1
            showPasswordAlert = true
            return false
        }
        
        if password != passwordConfirm {
            passwordAlertMessage = SettingsView.passwordErrorMessage2
            showPasswordAlert = true
            return false
        }
        
        // Password Ok
        return true
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LocalAuthManager())
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
    static let passwordErrorTitle = LocalizedStringKey("SettingsView.ErrorTitle")
    static let passordErrorButton = LocalizedStringKey("SettingsView.OK")
    static let passwordErrorMessage1 = LocalizedStringKey("SettingsView.ErrorMessage1")
    static let passwordErrorMessage2 = LocalizedStringKey("SettingsView.ErrorMessage2")
    static let passwordErrorMessage3 = LocalizedStringKey("SettingsView.ErrorMessage3")
    
}
