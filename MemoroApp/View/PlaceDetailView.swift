//
//  PlaceDetailView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 27/03/23.
//

import SwiftUI

struct PlaceDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var place: Location
    
    var body: some View {
        Text(place.title)
            .navigationTitle(place.title)
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(place: Location.example)
    }
}
