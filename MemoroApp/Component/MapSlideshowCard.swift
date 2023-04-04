//
//  MapSlideshowCard.swift
//  MemoroApp
//
//  Created by Antonio Casto on 31/03/23.
//

import SwiftUI
import MapKit

struct MapSlideshowCard: View {
    
    let width: CGFloat
    let height: CGFloat
    let place: Location
    let coordinate: CLLocationCoordinate2D
    
    @State private var snapshotImage: UIImage? = nil
    
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    
    var body: some View {
        Group {
            if let image = snapshotImage {
                ZStack {
                    
                    ImageSlideshowCard(width: width, height: height, place: place, image: image)
                    
                    MapPointer()
                    
                }
            } else {
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: width, height: height)
                    .foregroundStyle(.thickMaterial)
                    .overlay {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                
            }
        }
        .animation(.default, value: snapshotImage)
        .task {
            await setImage()
        }
    }
    
    @MainActor
    private func setImage() async {
        snapshotImage = await MKMapSnapshotterHelper.generateSnapshot(width: width, height: height, coordinate: coordinate, themePreference: themePreference)
    }
    
}

struct MapSlideshowCard_Previews: PreviewProvider {
    static var previews: some View {
        MapSlideshowCard(width: 400, height: 250, place: Location.example, coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2))
    }
}
