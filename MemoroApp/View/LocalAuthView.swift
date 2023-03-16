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
            
            Spacer()
            
        }
        .alert(LocalAuthView.authErrorTitle, isPresented: $localAuthManager.showAlert) {
            Button(LocalAuthView.okButtonText, role: .cancel) { }
            Button(LocalAuthView.openSettingsButtonText) {
                // Get the App Settings URL in iOS Settings and open it.
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(localAuthManager.errorDescription ?? LocalAuthView.unknownError)
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
}
