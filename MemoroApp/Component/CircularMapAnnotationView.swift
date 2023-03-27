//
//  CircularMapAnnotationView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 26/03/23.
//

import SwiftUI

struct CircularMapAnnotationView: View {
    
    let image: UIImage
    let borderColor: Color
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .padding(2)
            .background(borderColor.opacity(0.7))
            .clipShape(Circle())
        
    }
}

struct CircularMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        CircularMapAnnotationView(image: UIImage(imageLiteralResourceName: "Logo"), borderColor: Color.red)
    }
}

