//
//  FormPlaceImage.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 23/03/23.
//

import SwiftUI

struct FormPlaceImage: View {
    
    let image: UIImage
    @State private var animation = false
    
    var body: some View {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .background(Color.backgroundColor)
                .foregroundColor(Color.foregroundColor)
                .cornerRadius(10)
                .opacity(animation ? 1 : 0)
                .blur(radius: animation ? 0 : 10)
                .scaleEffect(animation ? 1.0 : 0.5)
                .onAppear {
                    withAnimation(.linear(duration: 0.3)) {
                        animation = true
                    }
                }
                .onDisappear {
                    withAnimation(.linear(duration: 0.3)) {
                        animation = false
                    }
                }
    }
}

struct FormPlaceImage_Previews: PreviewProvider {
    static var previews: some View {
        FormPlaceImage(image: UIImage(imageLiteralResourceName: "Logo"))
    }
}
