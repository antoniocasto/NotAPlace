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
