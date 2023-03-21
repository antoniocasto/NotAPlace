//
//  PhotoPicker.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    // Classe delegata per rispondere alle interazioni
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // 1. Tell the picker to go away
            picker.dismiss(animated: true)
            
            // 2. Exit if no selection was made by the user
            guard let provider = results.first?.itemProvider else { return }
            
            // 3. If this has an image we can use, use it
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
        
        
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Create and set picker configuration
        var config = PHPickerConfiguration()
        // Only images
        config.filter = .images
        
        // Picker with that configuration
        let picker = PHPickerViewController(configuration: config)
        
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Not used for now
    }
    
    func makeCoordinator() -> Coordinator {
        // return omesso
        Coordinator(self)
    }
    
}

