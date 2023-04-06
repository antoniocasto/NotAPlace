//
//  ImageHelper.swift
//  MemoroApp
//
//  Created by Antonio Casto on 06/04/23.
//

import SwiftUI

class ImageHelper {
    
    static let userImageKey = "UserImage"
    
    static func saveProfileImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: ImageHelper.userImageKey)
    }

    static func loadProfileImage() -> UIImage? {
         guard let data = UserDefaults.standard.data(forKey: ImageHelper.userImageKey) else { return UIImage(imageLiteralResourceName: "Logo") }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         return UIImage(data: decoded)
    }
}
