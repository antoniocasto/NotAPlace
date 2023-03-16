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
    
    let lockTitleText = "Memoro is Locked"
    let lockReasonText = "Unlock to show your places."
    let unlockButtonText = "Unlock"
    let authErrorTitle = "Authentication Error"
    let unknownError = "Unknown Error"
    let okButtonText = "OK"
    let openSettingsButtonText = "Open Settings"
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Spacer()
            Spacer()
            
            Image(systemName: "lock.fill")
                .font(.system(size: 120))
                .foregroundColor(.accentColor)
            
            
            Text(lockTitleText)
                .font(.title.bold())
                .foregroundColor(.accentColor)
            
            Text(lockReasonText)
                .foregroundColor(.accentColor)
            
            
            Spacer()
            
            unlockButton
            
            Spacer()
            
        }
        .alert(authErrorTitle, isPresented: $localAuthManager.showAlert) {
            Button(okButtonText, role: .cancel) { }
            Button(openSettingsButtonText) {
                // Get the App Settings URL in iOS Settings and open it.
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(localAuthManager.errorDescription ?? unknownError)
        }
        .task {
            await localAuthManager.authenticateWithBiometrics()
        }
        
        
        
    }
    
    var unlockButton: some View {
        Button {
            Task {
                await localAuthManager.authenticateWithBiometrics()
            }
        } label: {
            Text(unlockButtonText)
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
