//
//  PlacesSlideshowView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 31/03/23.
//

import SwiftUI
import MapKit
import Combine

struct PlacesSlideshowView: View {
    
    @EnvironmentObject var placeManager: PlaceManager
    
    @AppStorage("SelectedTab") var selectedTab: TabNavigationView.TabSelectable = .places
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    @State private var showPlaceDetail = false
    @State private var selectedPlace: Location?
    @State private var currentIndex: Int = 0
    @State private var backgroundImage: Thumbnail?
    @State private var thumbnails = [Thumbnail]()
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if placeManager.places.count != 0 {
                    
                    carousel
                        .background {
                            if let thumbnail = backgroundImage {
                                Image(uiImage: thumbnail.image)
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    .scaledToFill()
                                    .overlay {
                                        Color.clear
                                            .background(.ultraThinMaterial)
                                    }
                                    .edgesIgnoringSafeArea(.top)
                                    .allowsHitTesting(false)
                                    .onChange(of: currentIndex) { newValue in
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            backgroundImage = thumbnails[newValue]
                                        }
                                    }
                            }
                        }
                    
                    
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
            .task {
                
                guard placeManager.places.count > 0 else { return }
                
                await computeThumbnails()
                backgroundImage = thumbnails[0]
            }
            .onDisappear {
                thumbnails = []
            }
            
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
                    ForEach(Array(thumbnails.enumerated()), id: \.offset) { index, thumbnail in
                        
                        SlideshowCard(image: thumbnail.image, width: imageWidth, height: pageHeight, showMapPointer: thumbnail.isMap, happinessRate: placeManager.places[index].emotionalRating, text: placeManager.places[index].title)
                            .onTapGesture {
                                selectedPlace = placeManager.places[index]
                                showPlaceDetail.toggle()
                            }
                            .frame(width: pageWidth, height: pageHeight)
                        
                    }
                }
                // Start from the center of the screen
                .padding(.horizontal, (proxy.size.width - pageWidth) / 2)
                .background {
                    SnapCarouselHelper(displayedElementIndex: $currentIndex, pageWidth: pageWidth, pageCount: thumbnails.count)
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
    
    private func computeThumbnails() async {
                
        for index in 0 ... (placeManager.places.count - 1) {
            if let imageName = placeManager.places[index].image {
                let thumbnail = await placeManager.loadThumbnail(imageName: imageName)
                thumbnails.append(Thumbnail(image: thumbnail, isMap: false))
            } else {
                guard let thumbnail = await MKMapSnapshotterHelper.generateSnapshot(width: 400, height: 400, coordinate: placeManager.places[index].coordinate, themePreference: themePreference).byPreparingThumbnail(ofSize: CGSize(width: 400, height: 400)) else { return }
                thumbnails.append(Thumbnail(image: thumbnail, isMap: true))
            }
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
    static let noPlacesText = LocalizedStringKey("PlacesSlideshowView.noPlacesText")
    static let startText = LocalizedStringKey("PlacesSlideshowView.startText")
}
