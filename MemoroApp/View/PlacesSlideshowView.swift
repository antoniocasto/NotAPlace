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
    
    @AppStorage("SelectedTab") var selectedTab: TabNavigationView.TabSelectable = .places
    
    @State private var showPlaceDetail = false
    @State private var selectedPlace: Location?
    
    @State private var dragMove:CGFloat = .zero
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if placeManager.places.count != 0 {
                    
                    carousel
                    
                } else {
                    
                    noPlacesPlaceholder
                    
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
    
    var carousel: some View {
        GeometryReader { proxy in
            
            let pageHeight: CGFloat = proxy.size.height / 1.15
            let pageWidth: CGFloat = proxy.size.width / 1.12
            let imageWidth: CGFloat = proxy.size.width / 1.17
            
            // Carousel with snap
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(placeManager.places) { place in
                        Group {
                            
                            if let imageName = place.image {
                                
                                let image = placeManager.loadImage(imageName: imageName)
                                
                                
                                ImageSlideshowCard(width: imageWidth, height: pageHeight, place: place, image: image)
                                
                                
                            } else {
                                MapSlideshowCard(width: imageWidth, height: pageHeight, place: place, coordinate: place.coordinate)
                                
                            }
                        }
                        .frame(width: pageWidth, height: pageHeight)
                    }
                }
                // Start from the center of the screen
                .padding(.horizontal, (proxy.size.width - pageWidth) / 2)
                .background {
                    SnapCarouselHelper(pageWidth: pageWidth, pageCount: placeManager.places.count)
                }
            }
            
        }
    }
    
    var noPlacesPlaceholder: some View {
        VStack(alignment: .center) {
            Image(systemName: "mappin.slash.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(PlacesSlideshowView.noPlacesText)
                .font(.title2.bold())
                .padding(8)
            
            Button(PlacesSlideshowView.startText) {
                selectedTab = .map
            }
            .bold()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    static let noPlacesText = LocalizedStringKey("PlacesSlideshowView.noPlacesText")
    static let startText = LocalizedStringKey("PlacesSlideshowView.startText")
}
