//
//  AddedPlaceMaterialCard.swift
//  MemoroApp
//
//  Created by Antonio Casto on 26/03/23.
//

import SwiftUI

enum ConfirmationCardIconSystemName: String {
    case confirm = "checkmark"
    case downloaded = "arrow.down"
    case deleted = "trash"
}

struct ConfirmationCard: View {
    
    var icon: ConfirmationCardIconSystemName
    
    @State private var showAnimation = false
    
    var body: some View {
        Image(systemName: icon.rawValue)
            .font(.system(size: 50).bold())
            .padding(40)
            .foregroundStyle(.secondary.blendMode(.difference))
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .opacity(showAnimation ? 1 : 0)
            .blur(radius: showAnimation ? 0 : 20)
            .shadow(radius: 2, y: 2)
            .onAppear {
                
                var now = DispatchTime.now()
                
                // Appear
                DispatchQueue.main.asyncAfter(deadline: now + 0.3) {
                    showAnimation = true
                    
                    // Trigger haptic feedback
                    successHaptic()
                }
                
                now = DispatchTime.now()
                
                // Disappear
                DispatchQueue.main.asyncAfter(deadline: now + 1.5) {
                    showAnimation = false
                }
                
            }
            .animation(.easeInOut(duration: 0.3), value: showAnimation)
    }
    
    private func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

struct AddedPlaceMaterialCard_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationCard(icon: .confirm)
            .preferredColorScheme(.dark)
    }
}
