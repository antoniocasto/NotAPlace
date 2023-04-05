//
//  AddedPlaceMaterialCard.swift
//  MemoroApp
//
//  Created by Antonio Casto on 26/03/23.
//

import SwiftUI

struct AddedPlaceMaterialCard: View {
    
    @State private var showAnimation = false
    
    var body: some View {
        Image(systemName: "checkmark")
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
                    simpleSuccess()
                }
                
                now = DispatchTime.now()
                
                // Disappear
                DispatchQueue.main.asyncAfter(deadline: now + 1.5) {
                    showAnimation = false
                }
                
            }
            .animation(.easeInOut(duration: 0.3), value: showAnimation)
    }
    
    private func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

struct AddedPlaceMaterialCard_Previews: PreviewProvider {
    static var previews: some View {
        AddedPlaceMaterialCard()
            .preferredColorScheme(.dark)
    }
}
