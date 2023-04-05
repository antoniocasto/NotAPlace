//
//  SlideshowCard.swift
//  MemoroApp
//
//  Created by Antonio Casto on 05/04/23.
//

import SwiftUI

struct SlideshowCard: View {
    
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    let showMapPointer: Bool
    let happinessRate: Location.HappinessRating
    let text: String
    
    var body: some View {
        ZStack {
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    if showMapPointer {
                        MapPointer()
                    }
                }
            
            HappinessIcon(happinessRate: happinessRate)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            
            Text(text)
                .font(.title2.bold())
                .lineLimit(1)
                .padding()
                .background(.ultraThinMaterial)
                .foregroundColor(.accentColor)
                .cornerRadius(20, corners: [.bottomLeft, .topRight])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.trailing)

            
        }
        .frame(width: width, height: height)
        .shadow(radius: 10, y: 10)
    }
}

struct SlideshowCard_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowCard(image: UIImage(imageLiteralResourceName: "Logo"), width: 200, height: 300, showMapPointer: true, happinessRate: .happy, text: "A Beatuiful Place")
    }
}
