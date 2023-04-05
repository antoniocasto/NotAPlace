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

struct PlaceDetailView: View {
    
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
    
    var inputCoordinate: CLLocationCoordinate2D = MapDetails.startingLocation
    var place: Location?
    
    private var coordinate: CLLocationCoordinate2D {
        if let place = place {
            return place.coordinate
        } else {
            return inputCoordinate
        }
    }
    
    private var detailViewMode: Bool {
        place != nil
    }
    
    let titleCharLimit = 50
    let descriptionCharLimit = 100
    
    @State private var title = ""
    
    @State private var emotionalRating: Location.HappinessRating = .happy
    
    @State private var description = ""
    
    @State private var showConfirmationCard = false
    
    @State private var editModeEnabled = false
    
    @State private var navTitle = navigationTitle
    
    
    var body: some View {
        
        GeometryReader { proxy in
            NavigationStack {
                
                let width = proxy.size.width
                
                ZStack {
                    
                    Form {
                        
                        Section {
                            
                            MapResume(width: width, height: 150, coordinate: coordinate)
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets()).onTapGesture {
                            hideKeyboard()
                        }
                        
                        
                        titleSection
                            .disabled(!editModeEnabled && detailViewMode)
                            .onTapGesture {
                                hideKeyboard()
                            }
                        
                        descriptionSection
                            .disabled(!editModeEnabled && detailViewMode)
                            .onTapGesture {
                                hideKeyboard()
                            }
                        
                        
                        happinessSection
                            .disabled(!editModeEnabled && detailViewMode)
                        
                        
                        if let uiImage = selectedImage {
                            
                            ZStack(alignment: .topTrailing) {
                                
                                FormPlaceImage(image: uiImage)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                
                                deleteImageButton
                                    .padding()
                                    .onTapGesture {
                                        self.pickedImageItem = nil
                                        self.selectedImage = nil
                                    }
                                    .opacity(!editModeEnabled && detailViewMode ? 0 : 1)
                                    .disabled(!editModeEnabled && detailViewMode)
                                
                                
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets()).onTapGesture {
                                hideKeyboard()
                            }
                            
                        }
                        
                        if editModeEnabled || !detailViewMode {
                            Section {
                                
                                HStack {
                                    
                                    cameraPicker
                                    
                                    
                                    photoPicker
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                
                                
                            } footer: {
                                Text(PlaceDetailView.imageReason)
                            }
                        }
                        
                        
                        if detailViewMode && !editModeEnabled {
                            openInMapsSection
                                .onTapGesture {
                                    hideKeyboard()
                                }
                        }
                        
                    }
                    
                    
                    if showConfirmationCard {
                        AddedPlaceMaterialCard()
                    }
                    
                }
                .animation(.easeInOut(duration: 0.3), value: selectedImage)
                .navigationTitle(navTitle)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $cameraCoordinatorShown) {
                    CameraImagePicker(isCoordinatorShown: $cameraCoordinatorShown, image: $selectedImage)
                        .ignoresSafeArea()
                }
                .toolbar {
                    
                    if !detailViewMode {
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(PlaceDetailView.cancelButton, role: .cancel) {
                                dismiss()
                            }
                            .tint(.accentColor)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                savePlace()
                            } label: {
                                Text(PlaceDetailView.saveButton).bold()
                            }
                            .tint(.accentColor)
                            .disabled(title.count == 0)
                        }
                        
                    } else {
                        
                        // Place Detail Mode
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(PlaceDetailView.cancelButton, role: .cancel) {
                                restoreValues()
                            }
                            .tint(.accentColor)
                            .opacity(editModeEnabled ? 1 : 0)
                            .disabled(!editModeEnabled)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                
                                if !editModeEnabled {
                                    editModeEnabled = true
                                } else {
                                    updatePlace()
                                }
                            } label: {
                                Text(editModeEnabled ? PlaceDetailView.saveButton : PlaceDetailView.editButton).bold()
                            }
                            
                        }
                        
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                deletePlace()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        
                    }
                    
                }
                .onAppear {
                    
                    if cameraDisabled {
                        permissionAlertDescription = PlaceDetailView.cameraError
                        showPermissionAlert = true
                    }
                    
                    if detailViewMode {
                        setInputPlaceParams()
                        
                    }
                    
                }
                .alert(PlaceDetailView.permissionError, isPresented: $showPermissionAlert) {
                    Button(PlaceDetailView.cancelButton, role: .cancel) { }
                    Button(PlaceDetailView.openSettingsButtonText) {
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
        .navigationBarBackButtonHidden(editModeEnabled)
        .toolbar(editModeEnabled ? .hidden : .visible, for: .tabBar)
        .toolbar(detailViewMode && editModeEnabled ? .visible : .hidden, for: .bottomBar)
        
    }
    
    var titleSection: some View {
        Section(PlaceDetailView.placeTitleSection) {
            
            HStack(alignment: .firstTextBaseline) {
                
                Image(systemName: "character")
                    .foregroundColor(.accentColor)
                
                VStack {
                    
                    TextField(PlaceDetailView.placeTitleSection, text: $title)
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
    
    var happinessSection: some View {
        Section(PlaceDetailView.happinessSection) {
            Picker(PlaceDetailView.happinessSection, selection: $emotionalRating) {
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
                    permissionAlertDescription = PlaceDetailView.cameraError
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
        Label(selectedImage == nil ? PlaceDetailView.pickImage : PlaceDetailView.changeImage, systemImage: "photo")
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
                TextField(PlaceDetailView.descriptionSectionHeader, text: $description, axis: .vertical)
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
                Text(PlaceDetailView.descriptionSectionHeader)
            }
        } footer: {
            Text(PlaceDetailView.descriptionSectionFooter)
        }
        
    }
    
    var openInMapsSection: some View {
        // Open in Maps
        Section {
            Button {
                openInMaps()
            } label: {
                HStack {
                    Label(PlaceDetailView.openInMapsString, systemImage: "map")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
    
    private func savePlace() {
        
        // Save new place here
        var newPlace = Location(title: title, description: description, image: nil, emotionalRating: emotionalRating, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        if let image = selectedImage {
            let imageUrl = placeManager.saveImage(image)
            
            newPlace.image = imageUrl
        }
        
        placeManager.addPlace(newPlace)
        
        confirmAndDismiss()
    }
    
    private func restoreValues() {
        
        //Disable edit mode
        editModeEnabled = false
        
        // Reset input place parameters
        setInputPlaceParams()
    }
    
    private func openInMaps() {
        
        guard let place = place else {
            return
        }
        
        guard let url = URL(string: "maps://?saddr=&daddr=\(place.latitude),\(place.longitude)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setInputPlaceParams() {
        if let place = place {
            navTitle = LocalizedStringKey(place.title)
            title = place.title
            emotionalRating = place.emotionalRating
            description = place.description
            
            if let image = place.image {
                selectedImage = placeManager.loadImage(imageName: image)
            }
            
        }
    }
    
    private func updatePlace() {
        
        guard let place = place else {
            return
        }
        
        var updatedPlace = Location(title: "", description: "", emotionalRating: .happy, latitude: place.latitude, longitude: place.longitude)
        
        
        // Delete old place image
        if let placeImage = place.image {
            placeManager.deleteImage(imageName: placeImage)
        }
        
        // Save new place image
        if let image = selectedImage {
            let imageUrl = placeManager.saveImage(image)
            updatedPlace.image = imageUrl
        } else {
            updatedPlace.image = nil
        }
        
        // Update title, description and emotional rating
        updatedPlace.title = title
        updatedPlace.description = description
        updatedPlace.emotionalRating = emotionalRating
        
        // Persist changes
        placeManager.updatePlaceAt(id: place.id, place: updatedPlace)
        
        editModeEnabled = false
        confirmAndDismiss()
        
    }
    
    private func deletePlace() {
        
        guard let place = place else {
            return
        }
        
        if let image = place.image {
            placeManager.deleteImage(imageName: image)
        }
        
        placeManager.deletePlace(place: place)
        
        editModeEnabled = false
        
        confirmAndDismiss()
        
    }
    
    private func confirmAndDismiss() {
        // Hide keyboard if open
        hideKeyboard()
        
        showConfirmationCard = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dismiss()
        }
    }
    
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        //        PlaceDetailView(place: .constant(Location.example))
        //            .environmentObject(PlaceManager())
        
        PlaceDetailView(place: Location.example)
            .environmentObject(PlaceManager())
        
    }
}

extension PlaceDetailView {
    static let navigationTitle = LocalizedStringKey("PlaceDetailView.NewPlace")
    static let placeTitleSection = LocalizedStringKey("PlaceDetailView.PlaceTitleSection")
    static let titleMaxChar = LocalizedStringKey("PlaceDetailView.TitleMaxChar")
    static let permissionError = LocalizedStringKey("PlaceDetailView.PermissionError")
    static let cancelButton = LocalizedStringKey("PlaceDetailView.Cancel")
    static let saveButton = LocalizedStringKey("PlaceDetailView.Save")
    static let openSettingsButtonText = LocalizedStringKey("PlaceDetailView.Open Settings")
    static let cameraError = LocalizedStringKey("PlaceDetailView.CameraError")
    static let imageReason = LocalizedStringKey("PlaceDetailView.ImageReason")
    static let pickImage = LocalizedStringKey("PlaceDetailView.PickImage")
    static let changeImage = LocalizedStringKey("PlaceDetailView.ChangeImage")
    static let happinessSection = LocalizedStringKey("PlaceDetailView.happinessSection")
    static let descriptionSectionHeader = LocalizedStringKey("PlaceDetailView.descriptionHeader")
    static let descriptionSectionFooter = LocalizedStringKey("PlaceDetailView.descriptionFooter")
    static let editButton = LocalizedStringKey("PlaceDetailView.editButton")
    static let openInMapsString = LocalizedStringKey("PlaceDetailView.openInMaps")
}
