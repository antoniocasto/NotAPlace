//
//  MapArea.swift
//  MemoroApp
//
//  Created by Antonio Casto on 20/03/23.
//

import SwiftUI
import MapKit

struct MapArea: View {
    
    @Binding var mapRegion: MKCoordinateRegion
    
    var body: some View {
        
        // To avoid publishing changes while Map updating warning
        Map(coordinateRegion: .constant(mapRegion), interactionModes: .all, showsUserLocation: true)
            .tint(.accentColor)
        
    }
}
