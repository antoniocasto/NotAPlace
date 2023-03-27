//
//  MapArea.swift
//  MemoroApp
//
//  Created by Antonio Casto on 20/03/23.
//

import SwiftUI
import MapKit

struct MapArea: View {
    
    @EnvironmentObject var placeManager: PlaceManager
    
    @Binding var mapRegion: MKCoordinateRegion
    let annotationItems: [Location]
    
    var body: some View {
        
        Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotationItems) { item in
            
            // This will generate a runtime warning. A fix on SwiftUI is needed.
            MapAnnotation(coordinate: item.coordinate) {
                if let itemImage = item.image {
                    CircularMapAnnotationView(image: placeManager.loadImage(imageName: itemImage), borderColor: item.emotionalRating.ratingColor)
                } else {
                    CircularMapAnnotationView(image: UIImage(imageLiteralResourceName: "Logo"), borderColor: item.emotionalRating.ratingColor)
                }
            }
            
        }
        .tint(.accentColor)
                
    }
}
