//
//  LocationManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 20/03/23.
//

import Foundation
import CoreLocation
import MapKit

enum MapDetails {
    static let startingLocation =
    CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private var manager = CLLocationManager()
    
    @Published var clAuthStatus: CLAuthorizationStatus = .authorizedWhenInUse
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @MainActor
    private func checkLocationAuthorization() {
                        
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            clAuthStatus = .notDetermined
        case .restricted:
            // Location is restricted i.e. due to parental controls.
            clAuthStatus = .restricted
        case .denied:
            // Location access denied
            clAuthStatus = .denied
        case .authorizedAlways, .authorizedWhenInUse:
            clAuthStatus = .authorizedWhenInUse
            guard let location = manager.location else { return }
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)

            }
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }
    
    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}
