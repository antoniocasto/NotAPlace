//
//  MapResume.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 01/04/23.
//

import SwiftUI
import MapKit

struct MapResume: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    @State private var snapshotImage: UIImage? = nil
    
    let width: CGFloat
    let height: CGFloat
    let coordinate: CLLocationCoordinate2D

    
    var body: some View {
        Group {
            if let image = snapshotImage {
                ZStack {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                    
                    MapPointer()
                    
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: width, height: height)
            }
        }
        .task {
            await setImage()
        }
        .onChange(of: colorScheme) { _ in
            Task {
                await setImage()
            }
        }
    }
    
    @MainActor
    private func setImage() async {
        snapshotImage = await MKMapSnapshotterHelper.generateSnapshot(width: width, height: height, coordinate: coordinate, themePreference: themePreference)
    }
    
}

struct MapResume_Previews: PreviewProvider {
    static var previews: some View {
        MapResume(width: 400, height: 200, coordinate: MapDetails.startingLocation)
    }
}
