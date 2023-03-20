//
//  LocalAuthView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI

struct LocalAuthView: View {
    
    // Manager for Local Authentication
    @EnvironmentObject var localAuthManager: LocalAuthManager
    
    // Persistent settings
    @AppStorage("LocalAuthWithBiometrics") private var localAuthWithBiometrics = false
    
    // Backup mode to login
    @State private var showLoginWithPassword = false
    @State private var showPasswordPrompt = false
    @State private var password = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Spacer()
            Spacer()
            
            Image(systemName: "lock.fill")
                .font(.system(size: 120))
                .foregroundColor(.accentColor)
            
            
            Text(LocalAuthView.lockTitleText)
                .font(.title.bold())
                .foregroundColor(.accentColor)
            
            Text(LocalAuthView.lockReasonText)
                .foregroundColor(.accentColor)
            
            
            Spacer()
            
            unlockButton
            
            if showLoginWithPassword {
                Text(LocalAuthView.unlockWithPasswordText)
                    .foregroundColor(.accentColor)
                    .padding()
                    .onTapGesture {
                        // Login With Password
                        showPasswordPrompt = true
                    }
            }
            
            Spacer()
            
        }
        // Alert for biometric authentication error
        .alert(LocalAuthView.authErrorTitle, isPresented: $localAuthManager.showAlert) {
            Button(LocalAuthView.okButtonText, role: .cancel) {
                withAnimation {
                    showLoginWithPassword = true
                }
            }
            Button(LocalAuthView.openSettingsButtonText) {
                // Get the App Settings URL in iOS Settings and open it.
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(localAuthManager.errorDescription ?? LocalAuthView.unknownError)
        }
        // Password prompt for Local Authentication
        .alert(LocalAuthView.unlockWithPasswordText, isPresented: $showPasswordPrompt) {
            SecureField(LocalAuthView.passwordInput, text: $password)
            Button(LocalAuthView.passwordCancelButton, role: .cancel) {
                password = ""
            }
            Button(LocalAuthView.passwordLoginButton) {
                
                // Perform login here
                localAuthManager.loginPassword(with: password)
                
            }
        } message: {
            Text(LocalAuthView.passowrdReasonText)
        }
        // Alert for wrong password in Local Authentication
        .alert(LocalAuthView.passwordErrorTitle, isPresented: $localAuthManager.showPasswordAlert) {
            Button(LocalAuthView.okButtonText, role: .cancel) {
                password = ""
            }
        } message: {
            Text(localAuthManager.passwordErrorDescription ?? LocalAuthView.unknownError)
        }
        .task {
            if localAuthWithBiometrics {
                await localAuthManager.authenticateWithBiometrics()
            }
        }
        
        
        
    }
    
    var unlockButton: some View {
        Button {
            if localAuthWithBiometrics {
                // Login via Biometrics
                Task {
                    await localAuthManager.authenticateWithBiometrics()
                }
            } else {
                // Login using password
                showPasswordPrompt = true
            }
        } label: {
            Text(LocalAuthView.unlockButtonText)
                .font(.title2)
                .bold()
                .padding()
                .background(Color.backgroundColor)
                .foregroundColor(Color.foregroundColor)
                .clipShape(Capsule())
                .shadow(color: Color.backgroundColor.opacity(0.3), radius: 10, x: 0, y: 10)
        }
    }
    
}

struct LocalAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LocalAuthView()
            .environmentObject(LocalAuthManager())
    }
}

extension LocalAuthView {
    static let lockTitleText = LocalizedStringKey("LocalAuthView.Memoro is Locked")
    static let lockReasonText = LocalizedStringKey("LocalAuthView.Unlock it to show your places.")
    static let unlockButtonText = LocalizedStringKey("LocalAuthView.Unlock")
    static let authErrorTitle = LocalizedStringKey("LocalAuthView.Authentication Error")
    static let unknownError = LocalizedStringKey("LocalAuthView.Unknown Error")
    static let okButtonText = LocalizedStringKey("LocalAuthView.OK")
    static let openSettingsButtonText = LocalizedStringKey("LocalAuthView.Open Settings")
    static let unlockWithPasswordText = LocalizedStringKey("LocalAuthView.UnlockPassword")
    static let passwordInput = LocalizedStringKey("LocalAuthView.Password")
    static let passwordCancelButton = LocalizedStringKey("LocalAuthView.Cancel")
    static let passwordLoginButton = LocalizedStringKey("LocalAuthView.Login")
    static let passowrdReasonText = LocalizedStringKey("LocalAuthView.PasswordReason")
    static let passwordErrorTitle = LocalizedStringKey("LocalAuthView.PasswordError")
}
