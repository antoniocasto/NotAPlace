//
//  PlacesSlideshowView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 31/03/23.
//

import SwiftUI
import MapKit

struct PlacesSlideshowView: View {
    
    @EnvironmentObject var placeManager: PlaceManager
    
    @State private var showPlaceDetail = false
    @State private var selectedPlace: Location?
        
    var body: some View {
        
        NavigationStack {
            GeometryReader { proxy in
                
                let width = proxy.size.width - (proxy.size.width * 10 / 100)
                let height = proxy.size.height  - (proxy.size.height * 10 / 100)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(placeManager.places) { place in
                            Group {
                                
                                if let imageName = place.image {
                                    
                                    let image = placeManager.loadImage(imageName: imageName)
                                    
                                    
                                    ImageSlideshowCard(width: width, height: height, place: place, image: image)
                                        .frame(width: width, height: height)
                                    
                                } else {
                                    MapSlideshowCard(width: width, height: height, place: place, coordinate: place.coordinate)
                                        .frame(width: width, height: height)
                                }
                            }
                            .onTapGesture {
                                selectedPlace = place
                                showPlaceDetail.toggle()
                            }

                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .ignoresSafeArea()
                }
                
            }
            .navigationDestination(isPresented: $showPlaceDetail) {
                if let place = selectedPlace {
                    PlaceDetailView(place: place)
                }
            }
            .navigationTitle(PlacesSlideshowView.navigationTitleText)
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

struct PlacesSlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesSlideshowView()
            .environmentObject(PlaceManager())
    }
}

extension PlacesSlideshowView {
    static let navigationTitleText = LocalizedStringKey("PlacesSlideshowView.navigationTitleText")
}
