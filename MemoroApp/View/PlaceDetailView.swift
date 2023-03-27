//
//  PlaceDetailView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 27/03/23.
//

import SwiftUI
import MapKit

struct PlaceDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var place: Location
    var region: MKCoordinateRegion {
        return MKCoordinateRegion(center: place.coordinate, span: MapDetails.defaultSpan)
    }
    
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let imageHeight = proxy.size.height / 3
            
            ZStack {
                
                Form {
                    
                    Section {
                        
                        ZStack {
                            
                            Map(coordinateRegion: .constant(region), showsUserLocation: true)
                                .frame(maxWidth: .infinity)
                                .frame(height: imageHeight / 1.5)
                                .cornerRadius(10)
                                .disabled(true)
                            
                            MapPointer()
                                                        
                        }
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    
                    
                    
                    
                    
                    // Open in Maps
                    Section {
                        Button {
                            openInMaps()
                        } label: {
                            Label(PlaceDetailView.openInMapsString, systemImage: "map")
                        }
                    }
                    
                }
                
            }
            
        }
        .navigationTitle(place.title)
    }
    
    private func openInMaps() {
        guard let url = URL(string: "maps://?saddr=&daddr=\(place.latitude),\(place.longitude)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(place: Location.example)
    }
}

extension PlaceDetailView {
    static let openInMapsString = LocalizedStringKey("PlaceDetailView.openInMaps")
}
