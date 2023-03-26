//
//  AddPlaceView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI
import MapKit
import PhotosUI
import AVFoundation

struct AddPlaceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var placeManager: PlaceManager
    
    @State private var pickedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var cameraCoordinatorShown = false
    
    @State private var showPermissionAlert = false
    @State private var permissionAlertDescription = LocalizedStringKey("")
    
    private var cameraDisabled: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .denied
    }
    
    let region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    let titleCharLimit = 50
    let descriptionCharLimit = 100
    
    @State private var title = ""
    
    @State private var happinessRate: Location.HappinessRating = .happy
    
    @State private var description = ""
    
    @State private var showAddedPlaceCard = false
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { proxy in
                
                let imageHeight = proxy.size.height / 3
                
                ZStack {
                    
                    Form {
                    
                    Section {
                        ZStack {
                            Map(coordinateRegion: .constant(region), showsUserLocation: true)
                                .frame(maxWidth: .infinity)
                                .frame(height: imageHeight / 1.5)
                                .cornerRadius(10)
                                .disabled(true)
                            
                            MapPointer()
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                    
                    titleSection
                    
                    sliderSection
                    
                    if let uiImage = selectedImage {
                        
                        ZStack(alignment: .topTrailing) {
                            
                            FormPlaceImage(image: uiImage)
                                .frame(maxWidth: .infinity)
                                .frame(height: imageHeight)
                            
                            deleteImageButton
                                .padding()
                                .onTapGesture {
                                    self.pickedImageItem = nil
                                    self.selectedImage = nil
                                    
                                }
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        
                    }
                    
                    
                    Section {
                        
                        HStack {
                            
                            cameraPicker
                            
                            
                            photoPicker
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        
                    } footer: {
                        Text(AddPlaceView.imageReason)
                    }
                    
                    descriptionSection
                    
                }
                    
                    if showAddedPlaceCard {
                        AddedPlaceMaterialCard()
                    }
                    
                }
                .animation(.easeInOut(duration: 0.3), value: selectedImage)
                .navigationTitle(AddPlaceView.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $cameraCoordinatorShown) {
                    CameraImagePicker(isCoordinatorShown: $cameraCoordinatorShown, image: $selectedImage)
                        .preferredColorScheme(.dark)
                }
                .toolbar {
                    
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            hideKeyboard()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down.fill")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(AddPlaceView.cancelButton, role: .cancel) {
                            dismiss()
                        }
                        .tint(.accentColor)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                            // Save new place here
                            var newPlace = Location(title: title, description: description, image: nil, emotionalRating: happinessRate, latitude: region.center.latitude, longitude: region.center.longitude)
                            
                            if let image = selectedImage {
                               let imageUrl = placeManager.saveImage(image)
                                
                                newPlace.image = imageUrl
                            }
                            
                            placeManager.addPlace(newPlace)
                            
                            showAddedPlaceCard = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss()
                            }
                                                        
                        } label: {
                            Text(AddPlaceView.saveButton).bold()
                        }
                        .tint(.accentColor)
                        .disabled(title.count == 0)
                        
                    }
                    
                }
            }
            .onAppear {
                if cameraDisabled {
                    permissionAlertDescription = AddPlaceView.cameraError
                    showPermissionAlert = true
                }
            }
            .alert(AddPlaceView.permissionError, isPresented: $showPermissionAlert) {
                Button(AddPlaceView.cancelButton, role: .cancel) { }
                Button(AddPlaceView.openSettingsButtonText) {
                    // Get the App Settings URL in iOS Settings and open it.
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text(permissionAlertDescription)
            }
            
        }
    }
    
    var titleSection: some View {
        Section(AddPlaceView.placeTitleSection) {
            
            HStack(alignment: .firstTextBaseline) {
                
                Image(systemName: "character")
                    .foregroundColor(.accentColor)
                
                
                VStack {
                    
                    TextField(AddPlaceView.placeTitleSection, text: $title)
                        .onChange(of: title) { newValue in
                            if newValue.count > titleCharLimit {
                                title = String(newValue.prefix(titleCharLimit))
                            }
                        }
                    
                    CharacterCounter(text: title, charLimit: titleCharLimit)
                    
                }
                
                
            }
            
        }
    }
    
    var sliderSection: some View {
        Section(AddPlaceView.happinessSection) {
            Picker(AddPlaceView.happinessSection, selection: $happinessRate) {
                ForEach(Location.HappinessRating.allCases, id: \.rawValue) { item in
                    HappinessIcon(happinessRate: item)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        
    }
    
    var deleteImageButton: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundStyle(.regularMaterial)
            .overlay(
                Image(systemName: "trash")
                    .font(.system(size: 20).bold())
                    .foregroundColor(Color.red)
            )
            .frame(width: 30, height: 30)
        
    }
    
    var cameraPicker: some View {
        Image(systemName: "camera")
            .font(.title3.bold())
            .padding()
            .background(cameraDisabled ? Color.gray.opacity(0.3) : Color.backgroundColor)
            .foregroundColor(cameraDisabled ? Color.white.opacity(0.3) : Color.foregroundColor)
            .clipShape(Circle())
            .onTapGesture {
                if cameraDisabled {
                    permissionAlertDescription = AddPlaceView.cameraError
                    showPermissionAlert = true
                } else {
                    cameraCoordinatorShown = true
                }
            }
    }
    
    var photoPicker: some View {
        PhotosPicker(selection: $pickedImageItem, matching: .images, photoLibrary: .shared()) {
            photoPickerLabel
        }
        .onChange(of: pickedImageItem) { newItem in
            Task {
                // Retrieve selected image in Data format
                guard let data = try? await newItem?.loadTransferable(type: Data.self) else {
                    print("Error converting image to type Data")
                    pickedImageItem = nil
                    return
                }
                
                selectedImage = UIImage(data: data)
                
            }
        }
    }
    
    var photoPickerLabel: some View {
        Label(selectedImage == nil ? AddPlaceView.pickImage : AddPlaceView.changeImage, systemImage: "photo")
            .font(.title3.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .foregroundColor(Color.foregroundColor)
            .cornerRadius(10)
    }
    
    var descriptionSection: some View {
        Section {
            VStack {
                TextField(AddPlaceView.descriptionSectionHeader, text: $description, axis: .vertical)
                    .onChange(of: description) { newValue in
                        if newValue.count > descriptionCharLimit {
                            description = String(newValue.prefix(descriptionCharLimit))
                        }
                    }
                    
                
                CharacterCounter(text: description, charLimit: descriptionCharLimit)
            }
        } header: {
            HStack {
                Image(systemName: "info.circle")
                Text(AddPlaceView.descriptionSectionHeader)
            }
        } footer: {
            Text(AddPlaceView.descriptionSectionFooter)
        }
        
    }
    
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
            .environmentObject(PlaceManager())
    }
}

extension AddPlaceView {
    static let navigationTitle = LocalizedStringKey("AddPlaceView.NewPlace")
    static let placeTitleSection = LocalizedStringKey("AddPlaceView.PlaceTitleSection")
    static let titleMaxChar = LocalizedStringKey("AddPlaceView.TitleMaxChar")
    static let permissionError = LocalizedStringKey("AddPlaceView.PermissionError")
    static let cancelButton = LocalizedStringKey("AddPlaceView.Cancel")
    static let saveButton = LocalizedStringKey("AddPlaceView.Save")
    static let openSettingsButtonText = LocalizedStringKey("AddPlaceView.Open Settings")
    static let cameraError = LocalizedStringKey("AddPlaceView.CameraError")
    static let imageReason = LocalizedStringKey("AddPlaceView.ImageReason")
    static let pickImage = LocalizedStringKey("AddPlaceView.PickImage")
    static let changeImage = LocalizedStringKey("AddPlaceView.ChangeImage")
    static let happinessSection = LocalizedStringKey("AddPlaceView.happinessSection")
    static let descriptionSectionHeader = LocalizedStringKey("AddPlaceView.descriptionHeader")
    static let descriptionSectionFooter = LocalizedStringKey("AddPlaceView.descriptionFooter")
}
