//
//  ImageHelper.swift
//  MemoroApp
//
//  Created by Antonio Casto on 06/04/23.
//

import SwiftUI

class ImageHelper {
    
    static let userImageKey = "UserImage"
    static let imageDirectory = "Images"

    
    static func saveProfileImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: userImageKey)
    }

    static func loadProfileImage() -> UIImage? {
         guard let data = UserDefaults.standard.data(forKey: userImageKey) else { return UIImage(imageLiteralResourceName: "Logo") }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         return UIImage(data: decoded)
    }
    
    static func saveImage(_ image: UIImage) -> String? {
        
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
    
    static func deleteImage(imageName: String) {
        
        let imagesDirectoryUrl = FileManager.documentsDirectory.appendingPathComponent(imageDirectory, conformingTo: .directory)
        
        
        do {
            
            if !FileManager.default.fileExists(atPath: imagesDirectoryUrl.path) {
                try FileManager.default.createDirectory(atPath: imagesDirectoryUrl.path, withIntermediateDirectories: false)
            }
            
            let url = imagesDirectoryUrl.appending(component: imageName)
            
            if FileManager.default.fileExists(atPath: url.absoluteString) {
                try FileManager.default.removeItem(at: url)
            }
            
        } catch {
            print("An error occured while deleting the image: \(error)")
        }
    }
    
    static func loadImage(imageName: String) -> UIImage {
        
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
    
    static func loadThumbnail(imageName: String) async -> UIImage {
        
        let url = FileManager.documentsDirectory.appending(component: imageDirectory).appending(component: imageName)
        
        do {
            
            let imageData = try Data(contentsOf: url)
            
            guard let image = await UIImage(data: imageData)?.byPreparingThumbnail(ofSize: CGSize(width: 400, height: 400)) else {
                print("Error loading image. Return default one.")
                return UIImage(imageLiteralResourceName: "Logo")
            }
            
            return image
            
            
        } catch {
            print("An error occured while loading an image: \(error)")
            return UIImage(imageLiteralResourceName: "Logo")
        }
    }
}
