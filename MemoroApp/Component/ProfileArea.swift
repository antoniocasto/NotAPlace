//
//  ProfileArea.swift
//  MemoroApp
//
//  Created by Antonio Casto on 06/04/23.
//

import SwiftUI

struct ProfileArea: View {
    
    var image: UIImage?
    var title = "Memoro"
    
    @State private var animation = false
    
    var body: some View {
        ZStack {
            
            animatedShapes
                .blur(radius: 15)
            
            imageAndTitle
                .animation(.default, value: image)
            
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
    }
    
    var imageAndTitle: some View {
        VStack {
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(uiImage: UIImage(imageLiteralResourceName: "Logo"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }
            
            
            Text(title)
                .font(.title.bold())
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
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

struct ProfileArea_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ProfileArea()
        }
    }
}
