//
//  WorldMapView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 16/03/23.
//

import SwiftUI
import MapKit

struct WorldMapView: View {
    
    @StateObject private var locationManager = LocationManager()
 
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true)
                    .tint(.accentColor)
                
                
                pointer
                
            }
            .edgesIgnoringSafeArea(.top)
            
            
        }
        // Alert for location access denied or error getting location 
        .alert(WorldMapView.errorTitle, isPresented: $locationManager.showErrorAlert) {
            Button(WorldMapView.cancelButton, role: .cancel) { }
            Button(WorldMapView.openSettingsButtonText) {
                // Get the App Settings URL in iOS Settings and open it.
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(WorldMapView.errorMessage)
        }
        // Alert for location access restricted
        .alert(WorldMapView.errorTitle, isPresented: $locationManager.showRestrictedSettingsAlert) {
            Button(WorldMapView.cancelButton, role: .cancel) { }
            Button(WorldMapView.openSettingsButtonText) {
                // Get the App Settings URL in iOS Settings and open it.
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(WorldMapView.errorRestrictionMessage)
        }
        
    }
    
    var pointer: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.3))
            .frame(width: 32, height: 32)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white.opacity(0.7))
            }
    }
    
}

struct WorldMapView_Previews: PreviewProvider {
    static var previews: some View {
        WorldMapView()
    }
}

extension WorldMapView {
    static let errorTitle = LocalizedStringKey("WorldMapView.ErrorTitle")
    static let cancelButton = LocalizedStringKey("WorldMapView.Cancel")
    static let openSettingsButtonText = LocalizedStringKey("WorldMapView.Open Settings")
    static let errorMessage = LocalizedStringKey("WorldMapView.Error Message")
    static let errorRestrictionMessage = LocalizedStringKey("WorldMapView.Error Restriction Message")
}
