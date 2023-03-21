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
    
    @State private var showAddPlaceView = false
 
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                MapArea(mapRegion: $locationManager.region)
                
                MapPointer()
                
                addButton
                
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
        // Sheet to present the view to add a place
        .sheet(isPresented: $showAddPlaceView) {
            AddPlaceView()
        }
        
    }
    
    var addButton: some View {
        Button {
            showAddPlaceView.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title.bold())
                .padding()
                .background(Color.backgroundColor)
                .foregroundColor(Color.foregroundColor)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
        .padding(.bottom)
        .shadow(color: Color.backgroundColor.opacity(0.4), radius: 10, x: 0, y: 10)
        
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
