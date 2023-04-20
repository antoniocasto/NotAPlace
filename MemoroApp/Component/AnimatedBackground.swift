//
//  AnimatedBackground.swift
//  MemoroApp
//
//  Created by Antonio Casto on 20/04/23.
//

import SwiftUI

struct AnimatedBackground: View {
    
    @State private var animation = false
    
    var body: some View {
        animatedShapes
            .blur(radius: 15)
    }
    
    var animatedShapes: some View {
        
        ZStack {
            
            Image(systemName: "hexagon.fill")
                .font(.system(size: 100))
                .foregroundStyle(LinearGradient(colors: [Color.foregroundColor, Color.backgroundColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                .offset(x: animation ? 170 : -170, y: animation ? 50 : -50)
                .rotationEffect(.degrees(animation ? 100 : 0))
            
            Image(systemName: "hexagon.fill")
                .font(.system(size: 100))
                .foregroundStyle(LinearGradient(colors: [Color.foregroundColor, Color.backgroundColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                .offset(x: animation ? -170 : 170, y: animation ? -50 : 50)
                .rotationEffect(.degrees(animation ? 100 : 0))
            
        }
        .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: animation)
        .onAppear {
            animation.toggle()
        }
    }
    
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground()
    }
}
