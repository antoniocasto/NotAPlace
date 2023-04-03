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
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if placeManager.places.count != 0 {
                    
                    slideshow
                    
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
    
    var slideshow: some View {
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
