//
//  PlaceManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

class PlaceManager: ObservableObject {
    
    let placeDirectory = "Places"
    let imageDirectory = "Images"
    
    @Published private(set) var places = [Location]()
    
    init() {
        loadPlaces()
    }
    
    func saveImage(_ image: UIImage) -> String? {
        
        let imageName = UUID().uuidString
        
        let url = FileManager.documentsDirectory.appending(component: imageDirectory).appending(component: imageName)
        
        guard let compressedImage = image.jpegData(compressionQuality: 0.7) else {
            fatalError("Error while compressing image.")
        }
        
        do {
            try compressedImage.write(to: url, options: .completeFileProtection)
            
            return imageName
        } catch {
            return nil
        }
        
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
        
        do {
            
            let encodedData = try Data(contentsOf: url)
            
            places = try JSONDecoder().decode([Location].self, from: encodedData)
            
            
        } catch {
            print(error)
            places = [Location]()
        }
    }
    
}


