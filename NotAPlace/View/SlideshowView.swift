//
//  SlideshowView.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 10/04/23.
//

import SwiftUI

struct SlideshowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var placeManager: PlaceManager
    
    @AppStorage("SelectedTab") var selectedTab: TabNavigationView.TabSelectable = .places
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    @State private var currentIndex: Int = 0
    @State private var backgroundImage: UIImage?
    
    @State private var searchActive = false
    
    @State private var selectedPlace: Location?
    @State private var showPlaceDetail = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                VStack {
                    
                    if placeManager.places.count != 0 {
                        
                        SearchBar(searchText: $placeManager.searchPlace, searchActive: $searchActive)
                            .padding(.horizontal)
                            .padding(.top)
                        
                    }
                    
                    if searchActive {
                        filteredList
                    } else {
                        carousel
                    }
                    
                }
                .background {
                    
                    if let backgroundImage = backgroundImage, placeManager.places.count != 0 {
                        Image(uiImage: backgroundImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay {
                                Color.clear
                                    .background(.ultraThinMaterial)
                            }
                            .ignoresSafeArea()
                    }
                    
                }
                
                
                if placeManager.places.count == 0 {
                    
                    ViewPlaceholder(iconSystemName: "mappin.slash.circle.fill", text: SlideshowView.noPlacesText) {
                        Button(SlideshowView.startText) {
                            selectedTab = .map
                        }
                        .bold()
                    }
                    
                }
                
                
                
            }
            .animation(.easeInOut(duration: 0.3), value: backgroundImage)
            .navigationDestination(isPresented: $showPlaceDetail) {
                PlaceDetailView(place: selectedPlace)
            }
            .task {
                await setup()
            }
            .onChange(of: currentIndex) { newValue in
                Task {
                    await setup()
                }
            }
            .onChange(of: colorScheme) { newValue in
                Task {
                    await setup()
                }
            }
            
        }
        
    }
    
    var carousel: some View {
        
        SnapCarousel(index: $currentIndex, items: placeManager.places) { place in
            
            GeometryReader { proxy in
                
                let size = proxy.size
                
                SlideshowCard(place: place, width: size.width, height: size.height)
                    .onTapGesture {
                        placeManager.searchPlace = ""
                        searchActive = false
                        selectedPlace = place
                        showPlaceDetail.toggle()
                    }
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16)
        .ignoresSafeArea(.keyboard)
        
    }
    
    var filteredList: some View {
        
        Group {
            
            if placeManager.filteredPlaces.count != 0 {
                
                List(placeManager.filteredPlaces) { place in
                    NavigationLink {
                        PlaceDetailView(place: place)
                    } label: {
                        
                        HStack {
                            Text(place.title)
                            
                            Spacer()
                            
                            HappinessIcon(happinessRate: place.emotionalRating)
                            
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                
            } else if placeManager.places.count != 0 {
                ViewPlaceholder(iconSystemName: "magnifyingglass", text: SlideshowView.noResultsText) { }
            }
            
        }
    }
    
    @MainActor
    private func setup() async {
        
        guard placeManager.places.count > 0 else {
            return
        }
        
        // Set correct index
        if currentIndex > placeManager.places.count - 1 {
            currentIndex -= 1
        }
        
        let place = placeManager.places[currentIndex]
        
        if let imageName = place.image {
            backgroundImage = await ImageHelper.loadThumbnail(imageName: imageName)
        } else {
            backgroundImage = await MKMapSnapshotterHelper.generateSnapshot(width: 400, height: 400, coordinate: place.coordinate, themePreference: themePreference).byPreparingThumbnail(ofSize: CGSize(width: 400, height: 400))
        }
        
    }
}

struct SlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowView()
            .environmentObject(PlaceManager())
    }
}

extension SlideshowView {
    static let navigationTitleText = LocalizedStringKey("SlideshowView.navigationTitleText")
    static let noPlacesText = LocalizedStringKey("SlideshowView.noPlacesText")
    static let startText = LocalizedStringKey("SlideshowView.startText")
    static let noResultsText = LocalizedStringKey("SlideshowView.noResultsFound")
}