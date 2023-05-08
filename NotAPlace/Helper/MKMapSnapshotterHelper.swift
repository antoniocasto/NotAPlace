//
//  MKMapSnapshotterHelper.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 01/04/23.
//

import Foundation
import MapKit

class MKMapSnapshotterHelper {
    
    static func generateSnapshot(width: CGFloat, height: CGFloat, coordinate: CLLocationCoordinate2D, themePreference: AppTheme) async -> UIImage {
        
        // The region the map should display.
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MapDetails.defaultSpan
        )
        
        // Map options
        let mapOptions = MKMapSnapshotter.Options()
        mapOptions.region = region
        mapOptions.size = CGSize(width: width + 15, height: height + 15)
        mapOptions.showsBuildings = true
        
        // Set light or dark mode
        switch themePreference {
        case .systemBased:
            break
        case .darkMode:
            mapOptions.traitCollection = UITraitCollection(userInterfaceStyle: .dark)
        case .lightMode:
            mapOptions.traitCollection = UITraitCollection(userInterfaceStyle: .light)
        }
        
        // Create the snapshotter and run it.
        let snapshotter = MKMapSnapshotter(options: mapOptions)
        
        do {
            
            let snapshot = try await snapshotter.start()
            
            return snapshot.image
            
        } catch {
            print("Error while generating image from map: \(error)")
        }
        
        return UIImage(imageLiteralResourceName: "Logo")
        
    }
    
}
