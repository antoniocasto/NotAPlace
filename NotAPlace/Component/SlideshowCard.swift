//
//  SlideshowCard2.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 10/04/23.
//

import SwiftUI

struct SlideshowCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    let place: Location
    let width: CGFloat
    let height: CGFloat
    
    @State private var image: UIImage?
    
    var body: some View {
        
        ZStack {
            
            if let image = image {
                
                // Image loaded
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay {
                        if place.image == nil {
                            MapPointer()
                        }
                    }
                
            } else {
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundStyle(.gray.opacity(0.5).gradient)
                    .overlay {
                        ProgressView()
                    }

                
            }
            
            HappinessIcon(happinessRate: place.emotionalRating)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            
            Text(place.title)
                .font(.title2.bold())
                .lineLimit(1)
                .padding()
                .background(.ultraThinMaterial)
                .foregroundColor(.accentColor)
                .cornerRadius(20, corners: [.bottomLeft, .topRight])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.trailing)

            
        }
        .frame(width: width, height: height)
        .shadow(radius: 10, y: 10)
        .task {
            await setup()
        }
        .onChange(of: colorScheme) { newValue in
            Task {
                await setup()
            }
        }
        
    }
    
    @MainActor
    private func setup() async {
        if let imageName = place.image {
            image = await ImageHelper.loadThumbnail(imageName: imageName)
        } else {
            image = await MKMapSnapshotterHelper.generateSnapshot(width: 400, height: 400, coordinate: place.coordinate, themePreference: themePreference).byPreparingThumbnail(ofSize: CGSize(width: 400, height: 400))
        }
    }
    
}

struct SlideshowCard_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowCard(place: Location.example, width: 300, height: 600)
    }
}
