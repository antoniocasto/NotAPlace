//
//  PlaceManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

@MainActor
class PlaceManager: ObservableObject {
    
    let placeDirectory = "Places"
    
    @Published private(set) var places = [Location]()
    
    @Published var searchPlace = ""
    
    var filteredPlaces: [Location] {
        
        if searchPlace != "" {
            return places.filter { $0.title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(searchPlace.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) }
        }
        
        return places
        
    }
    
    init() {
        loadPlaces()
    }
    
    func addPlace(_ place: Location) {
        do {
            places.append(place)
            let url = FileManager.documentsDirectory.appending(component: placeDirectory)
            let encoded = try JSONEncoder().encode(places)
            try encoded.write(to: url, options: .completeFileProtection)
            
        } catch {
            print(error)
            loadPlaces()
        }
    }
    
    private func loadPlaces() {
        
        let url = FileManager.documentsDirectory.appending(component: placeDirectory)
        
        guard FileManager.default.fileExists(atPath: url.path()) else {
            places = [Location]()
            return
        }
        
        do {
            
            let encodedData = try Data(contentsOf: url)
            
            places = try JSONDecoder().decode([Location].self, from: encodedData)
            
            
        } catch {
            print(error)
            places = [Location]()
        }
    }
    
    func deletePlace(place: Location) {
        do {
            places.removeAll { $0.id == place.id}
            let url = FileManager.documentsDirectory.appending(component: placeDirectory)
            let encoded = try JSONEncoder().encode(places)
            try encoded.write(to: url, options: .completeFileProtection)
            
            guard let image = place.image else {
                return
            }
            
            ImageHelper.deleteImage(imageName: image)
            
        } catch {
            print(error)
            loadPlaces()
        }
    }
    
    func updatePlaceAt(id: UUID, place: Location) {
        do {
            
            let optionalIndex = places.firstIndex{ $0.id == id }
            
            guard let i = optionalIndex else {
                return
            }
            
            places[i] = place
            
            let url = FileManager.documentsDirectory.appending(component: placeDirectory)
            let encoded = try JSONEncoder().encode(places)
            try encoded.write(to: url, options: .completeFileProtection)
            
            loadPlaces()
            
        } catch {
            print(error)
            loadPlaces()
        }
    }
    
}


