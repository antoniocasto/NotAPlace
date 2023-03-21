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
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private var manager = CLLocationManager()
        
    @Published var showErrorAlert = false
    @Published var showRestrictedSettingsAlert = false
    
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
        case .restricted:
            // Location is restricted i.e. due to parental controls.
            showRestrictedSettingsAlert = true
        case .denied:
            // Location access denied
            showErrorAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = manager.location else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
        showErrorAlert = true
    }
    
    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}