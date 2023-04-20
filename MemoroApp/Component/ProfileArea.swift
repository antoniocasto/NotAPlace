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
    
    
    var body: some View {
        ZStack {
            
            AnimatedBackground()
            
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
        
}

struct ProfileArea_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ProfileArea()
        }
    }
}
