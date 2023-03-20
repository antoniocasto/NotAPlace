//
//  LocalAuthManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI
import LocalAuthentication

class LocalAuthManager: ObservableObject {
    
    // For Keychain
    private let account = "Local"
        
    // Evaluates auth policies
    private(set) var context = LAContext()
    
    // Available biometry type
    @Published private(set) var biometryType: LABiometryType = .none
    
    private(set) var canEvaluatePolicy = false
    
    // Auth state
    @Published private(set) var isAuthenticated = false
    
    // Error handling
    @Published private(set) var errorDescription: LocalizedStringKey?
    @Published var showAlert = false
    @Published private(set) var passwordErrorDescription: LocalizedStringKey?
    @Published var showPasswordAlert = false
    
    init() {
        
        // Sets biometry type
        getBiometryType()
        
    }
    
    func getBiometryType() {
        
        // Check if device contains biometric sensors (Face ID and Touch ID)
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        // Set biometry type
        biometryType = context.biometryType
        
    }
    
    @MainActor
    func authenticateWithBiometrics() async {
        
        context = LAContext()
                        
        guard canEvaluatePolicy else {
            showAlertErrorWithMessage(LocalAuthManager.biometricPermissionNotAllowedMessage)
            return
        }
        
        do {
            
            // Set auth status
            isAuthenticated = try await context.evaluatePolicy(biometryType == .none ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics, localizedReason: unlockReason)
            
            // Clear error message if any
            clearErrorMessage()
                        
        } catch {
                        
            print(error.localizedDescription)
            
            // Optional - Show error
//            errorDescription = error.localizedDescription
//            showAlert = true
            
            // Set to .none to let the user using his credentials
            biometryType = .none
            isAuthenticated = false
        }
    }
    
    func logout() {
        isAuthenticated = false
    }
    
    // Local auth method: Login - Implement later
    func loginPassword(with password: String) {
        
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        
        // Get stored password from Keychain
        guard let encodedPassword = KeychainHelper.read(service: bundleID, account: account) else { return }
        
        // Decode password
        guard let decodedPassword = String(data: encodedPassword, encoding: .utf8) else { return }
                
        if password == decodedPassword {
            
            clearErrorMessage(forPassword: true)
            isAuthenticated = true
            
        } else {
            showAlertErrorWithMessage(LocalAuthManager.wrongPasswordMessage, forPassword: true)
        }
        
    }
    
    // Local auth method: Password Creation
    func createPassword(with password: String) {
        
        // Encode password and obtain Bundle id
        guard let encodedPassword = password.data(using: .utf8), let bundleID = Bundle.main.bundleIdentifier else { return }
                            
        // Store password in Keychain
        KeychainHelper.save(encodedPassword, service: bundleID, account: "Local")
        
    }
    
    private func showAlertErrorWithMessage(_ messageKey: LocalizedStringKey, forPassword: Bool = false) {
        
        if forPassword {
            passwordErrorDescription = messageKey
            showPasswordAlert = true
            return
        }
        
        errorDescription = messageKey
        showAlert = true
    }
    
    private func clearErrorMessage(forPassword: Bool = false) {
        
        if forPassword {
            passwordErrorDescription = nil
            showPasswordAlert = false
            return
        }
        
        errorDescription = nil
        showAlert = false
    }
    
}

extension LocalAuthManager {
    
    static let biometricPermissionNotAllowedMessage = LocalizedStringKey("LocalAuthManager.disabled")
    static let wrongPasswordMessage = LocalizedStringKey("LocalAuthManager.wrongPassword")
    
    // Same as info.plist, check Localizable files.
    var unlockReason: String {
        let langStr = NSLocale.current.language.languageCode?.identifier ?? "en"
        switch langStr {
        case "it":
            return "Abbiamo bisogno di questo permesso per sbloccare i luoghi che hai salvato."
        case "en":
            return "We need this permission to unlock your saved places."
        default:
            return "We need this permission to unlock your saved places."
        }
    }
    
}
