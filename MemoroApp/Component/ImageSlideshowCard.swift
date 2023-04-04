//
//  SlideshowCard.swift
//  MemoroApp
//
//  Created by Antonio Casto on 31/03/23.
//

import SwiftUI
import MapKit

struct ImageSlideshowCard: View {
    
    let width: CGFloat
    let height: CGFloat
    let place: Location
    let image: UIImage
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
 
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .overlay(alignment: .topTrailing) {
                    HappinessIcon(happinessRate: place.emotionalRating, fontSize: 25)
                        .padding()
                }
            
            placeTitle
            
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .ignoresSafeArea()
        
    }
    
    var placeTitle: some View {
        Text(place.title)
            .font(.system(.largeTitle, design: .serif, weight: .bold))
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20, corners: .topRight)
            .lineLimit(1)
    }
    
}

struct ImageSlideshowCard_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlideshowCard(width: 250, height: 400, place: Location.example, image: UIImage(imageLiteralResourceName: "Logo"))
    }
}
