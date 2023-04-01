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
                    Image(systemName: place.emotionalRating.ratingIconName)
                        .font(.title2)
                        .foregroundColor(place.emotionalRating.ratingColor)
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 3)
                                .foregroundColor(.white.opacity(0.7))
                            
                        }
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
