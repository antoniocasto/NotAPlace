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
    let imageDirectory = "Images"
    
    @Published private(set) var places = [Location]()
    
    init() {
        loadPlaces()
    }
    
    func saveImage(_ image: UIImage) -> String? {
        
        let imageName = UUID().uuidString
        
        let imagesDirectoryUrl = FileManager.documentsDirectory.appendingPathComponent(imageDirectory, conformingTo: .directory)
        
        
        do {
            
            if !FileManager.default.fileExists(atPath: imagesDirectoryUrl.path) {
                try FileManager.default.createDirectory(atPath: imagesDirectoryUrl.path, withIntermediateDirectories: false)
            }
            
            let url = imagesDirectoryUrl.appending(component: imageName)
            
            
            guard let compressedImage = image.jpegData(compressionQuality: 0.7) else {
                fatalError("Error while compressing image.")
            }
            
            try compressedImage.write(to: url, options: .completeFileProtection)
            
            return imageName
        } catch {
            print("An error occured while saving the image: \(error)")
            return nil
        }
        
    }
    
    func loadImage(imageName: String) -> UIImage {
        
        let url = FileManager.documentsDirectory.appending(component: imageDirectory).appending(component: imageName)
        
        do {
            
            let imageData = try Data(contentsOf: url)
            
            guard let image = UIImage(data: imageData) else {
                print("Error loading image. Return default one.")
                return UIImage(imageLiteralResourceName: "Logo")
            }
                    
            return image
            
            
        } catch {
            print("An error occured while loading an image: \(error)")
            return UIImage(imageLiteralResourceName: "Logo")
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
    
}


