//
//  LocalAuthManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import Foundation
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
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false
        
    // Same as info.plist
    let unlockReason = "We need to authenticate you to unlock your places."
    
    let biometricPermissionNotAllowedMessage = "Biometric authentication or device code authentication has been disabled for Memoro from the iOS Settings. Reactivate this setting to use it."
    
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
            showAlertErrorWithMessage(biometricPermissionNotAllowedMessage)
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
    
    private func showAlertErrorWithMessage(_ message: String) {
        errorDescription = message
        showAlert = true
    }
    
    private func clearErrorMessage() {
        errorDescription = nil
        showAlert = false
    }
    
}
