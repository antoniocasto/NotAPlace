//
//  CameraImagePicker.swift
//  MemoroApp
//
//  Created by Antonio Casto on 23/03/23.
//

import SwiftUI

struct CameraImagePicker: UIViewControllerRepresentable {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            parent.image = unwrapImage
            parent.isCoordinatorShown = false
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isCoordinatorShown = false
        }
        
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

