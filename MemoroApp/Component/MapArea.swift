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
    @Binding var showPlaceDetailView: Bool
    @Binding var selectedPlace: Location?
    
    var body: some View {
        
        Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: placeManager.places) { item in
            
            // MapAnnotation generates runtime warnings. A SwiftUI fix seems to be needed.
            MapAnnotation(coordinate: item.coordinate) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.title3).bold()
                    .foregroundColor(item.emotionalRating.ratingColor)
                    .onTapGesture {
                        selectedPlace = item
                        showPlaceDetailView.toggle()
                    }
            }
            
        }
        .tint(.accentColor)
                
    }
}
