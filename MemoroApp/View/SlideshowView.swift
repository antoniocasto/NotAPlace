//
//  SlideshowView.swift
//  MemoroApp
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
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                VStack(spacing: 0) {
                    
                    if placeManager.places.count != 0 {
                        
                        SearchBar(searchText: $placeManager.searchPlace, searchActive: $searchActive)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                    }
                    
                    carousel
                    
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
                    
                    placeholder
                    
                }
                
                
                
            }
            .animation(.easeInOut(duration: 0.3), value: backgroundImage)
            .onTapGesture {
                
                placeManager.searchPlace = ""
                
                withAnimation {
                    searchActive = false
                }
                hideKeyboard()
            }
            
        }
        
    }
    
    var carousel: some View {
        GeometryReader { proxy in
            
            let pageHeight: CGFloat = proxy.size.height / 1.10
            let pageWidth: CGFloat = proxy.size.width / 1.12
            let imageWidth: CGFloat = proxy.size.width / 1.17
            
            // Carousel with snap
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(placeManager.filteredPlaces) { place in
                        
                        NavigationLink {
                            PlaceDetailView(place: place)
                        } label: {
                            SlideshowCard(place: place, width: imageWidth, height: pageHeight)
                        }
                        .frame(width: pageWidth)
                        
                        
                    }
                }
                // Start from the center of the screen
                .padding(.horizontal, (proxy.size.width - pageWidth) / 2)
                .background {
                    SnapCarouselHelper(displayedElementIndex: $currentIndex, pageWidth: pageWidth, pageCount: placeManager.places.count)
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
            .disabled(placeManager.places.isEmpty)
            
        }
        
    }
    
    var placeholder: some View {
        VStack(alignment: .center) {
            Image(systemName: "mappin.slash.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(SlideshowView.noPlacesText)
                .font(.title2.bold())
                .padding(8)
            
            Button(SlideshowView.startText) {
                selectedTab = .map
            }
            .bold()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    static let navigationTitleText = LocalizedStringKey("PlacesSlideshowView.navigationTitleText")
    static let noPlacesText = LocalizedStringKey("PlacesSlideshowView.noPlacesText")
    static let startText = LocalizedStringKey("PlacesSlideshowView.startText")
    
}
