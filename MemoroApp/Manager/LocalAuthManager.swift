//
//  LocalAuthManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI
import LocalAuthentication

class LocalAuthManager: ObservableObject {
        
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
        }
    }
    
    func logout() {
        isAuthenticated = false
    }
    
    private func showAlertErrorWithMessage(_ messageKey: LocalizedStringKey) {
        errorDescription = messageKey
        showAlert = true
    }
    
    private func clearErrorMessage() {
        errorDescription = nil
        showAlert = false
    }
    
}

extension LocalAuthManager {
    static let biometricPermissionNotAllowedMessage = LocalizedStringKey("LocalAuthManager.disabled")
    
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

