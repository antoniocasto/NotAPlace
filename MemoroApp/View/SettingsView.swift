//
//  SettingsView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 15/03/23.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    
    // Manager for Local Authentication
    @EnvironmentObject var localAuthManager: LocalAuthManager
    
    // Persistent settings
    @AppStorage("LocalAuthEnabled") private var localAuthEnabled = false
    @AppStorage("LocalAuthWithBiometrics") private var localAuthWithBiometrics = false
    @AppStorage("ThemePreference") private var themePreference: AppTheme = .systemBased
    
    @AppStorage("UserName") private var username = ""
    
    @State private var pickedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showPhotoDialog = false
    @State private var showPhotoGalleryPicker = false
    @State private var cameraCoordinatorShown = false

    
    @State private var enableLocalAuth = false
    @State private var enableBiometricAuthToggle = false
    @State private var showPasswordInput = false
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var showPasswordAlert = false
    @State private var passwordAlertMessage = LocalizedStringKey("")
    
    @State private var showPermissionAlert = false
    @State private var permissionAlertDescription = LocalizedStringKey("")
    
    let usernameCharLimit = 20
    
    private var profileUsername: String {
        if username.isEmpty {
            return "Memoro"
        } else {
            return username
        }
    }
    
    private var cameraDisabled: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .denied
    }
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                ProfileArea(image: selectedImage , title: profileUsername)
                    .onAppear {
                        selectedImage = ImageHelper.loadProfileImage()
                    }

                
                Section {
                    
                    HStack {
                        
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.secondary)
                        
                        TextField(SettingsView.userNameText, text: $username)
                            .onChange(of: username) { newValue in
                                if newValue.count > usernameCharLimit {
                                    username = String(newValue.prefix(usernameCharLimit))
                                }
                        }
                    }
                    
                    HStack {
                        
                        Image(systemName: "camera.circle.fill")
                            .foregroundColor(.secondary)
                        
                        Button(SettingsView.userPhotoText) {
                            showPhotoDialog.toggle()
                        }
                        .tint(.accentColor)
                        .confirmationDialog(SettingsView.confirmationDialogText, isPresented: $showPhotoDialog) {
                            Button(SettingsView.cameraText) {
                                if cameraDisabled {
                                    permissionAlertDescription = SettingsView.cameraError
                                    showPermissionAlert = true
                                } else {
                                    cameraCoordinatorShown = true
                                }
                            }
                            
                            Button(SettingsView.photoLibraryText) {
                                showPhotoGalleryPicker.toggle()
                            }
                            
                        }
                        .sheet(isPresented: $cameraCoordinatorShown) {
                            CameraImagePicker(isCoordinatorShown: $cameraCoordinatorShown, image: $selectedImage)
                                .ignoresSafeArea()
                        }
                        .photosPicker(isPresented: $showPhotoGalleryPicker, selection: $pickedImageItem, matching: .images, photoLibrary: .shared())
                        .onChange(of: pickedImageItem) { newItem in
                            Task {
                                // Retrieve selected image in Data format
                                guard let data = try? await newItem?.loadTransferable(type: Data.self) else {
                                    print("Error converting image to type Data")
                                    pickedImageItem = nil
                                    return
                                }
                                
                                let image = UIImage(data: data)
                                
                                selectedImage = image
                                
                                if let image = image {
                                    ImageHelper.saveProfileImage(image: image)
                                }
                                
                            }
                        }
                        
                    }
                    
                } header: {
                    HStack {
                        Image(systemName: "person")
                        Text(SettingsView.userProfileText)
                    }
                }
                
                
                Section {
                    
                    Toggle(SettingsView.localAuthToggleText, isOn: $enableLocalAuth)
                        .onChange(of: enableLocalAuth) { newValue in
                            if newValue {
                                // If Local Authentication is enabled. A password must be set.
                                showPasswordInput = true
                            } else {
                                // Disable Local Auth
                                localAuthEnabled = false
                                localAuthWithBiometrics = false
                            }
                        }
                    
                    // Show only if Local Auth is enabled
                    // and Face ID or Touch ID is available
                    if localAuthEnabled && localAuthManager.canEvaluatePolicy {
                        Toggle(SettingsView.biometricsLocalAuthToggleText, isOn: $enableBiometricAuthToggle)
                            .disabled(!localAuthEnabled)
                            .onChange(of: enableBiometricAuthToggle) { newValue in
                                if newValue {
                                    Task {
                                        await localAuthManager.authenticateWithBiometrics()
                                        localAuthWithBiometrics = localAuthManager.isAuthenticated
                                    }
                                } else {
                                    localAuthWithBiometrics = false
                                }
                            }
                    }
                    
                } header: {
                    Label(SettingsView.securitySectionHeaderText, systemImage: "lock")
                } footer: {
                    Text(SettingsView.securitySectionFooterText)
                }
                
                Section {
                    Picker(SettingsView.themePickerText, selection: $themePreference) {
                        ForEach(AppTheme.allCases, id: \.hashValue) { theme in
                            Text(theme.themeName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Label(SettingsView.themeSectionHeaderText, systemImage: "paintpalette")
                }
                
            }
            // Alert for password creation
            .alert(SettingsView.passwordAlertTitle, isPresented: $showPasswordInput, actions: {
                SecureField(SettingsView.passwordInput, text: $password)
                SecureField(SettingsView.passwordConfirmInput, text: $passwordConfirm)
                Button(SettingsView.cancelButton, role: .cancel) {
                    // Disable Local Authentication if password is not set.
                    localAuthEnabled = false
                    enableLocalAuth = false
                }
                Button(SettingsView.passwordCreateButton) {
                    
                    // Store password.
                    // Password validity checks
                    let checkPassed = checkPasswordValidity()
                    
                    // Store password
                    localAuthManager.createPassword(with: password)
                    
                    // Enable Local Password if checks are okay
                    enableLocalAuth = checkPassed
                    localAuthEnabled = checkPassed
                    
                }
            }, message: {
                Text(SettingsView.passwordAlertMessage)
            })
            // Alert for invalid password
            .alert(SettingsView.passwordErrorTitle, isPresented: $showPasswordAlert) {
                Button(SettingsView.passordErrorButton, role: .cancel) {
                    password = ""
                    passwordConfirm = ""
                }
            } message: {
                Text(passwordAlertMessage)
            }
            .alert(SettingsView.permissionError, isPresented: $showPermissionAlert) {
                Button(SettingsView.cancelButton, role: .cancel) { }
                Button(SettingsView.openSettingsButtonText) {
                    // Get the App Settings URL in iOS Settings and open it.
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text(permissionAlertDescription)
            }
            .navigationTitle(SettingsView.viewTitleText)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            enableLocalAuth = localAuthEnabled
            enableBiometricAuthToggle = localAuthWithBiometrics
        }
    }
    
    private func checkPasswordValidity() -> Bool {
        
        if password.count < 8 {
            passwordAlertMessage = SettingsView.passwordErrorMessage1
            showPasswordAlert = true
            return false
        }
        
        if password != passwordConfirm {
            passwordAlertMessage = SettingsView.passwordErrorMessage2
            showPasswordAlert = true
            return false
        }
        
        // Password Ok
        return true
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LocalAuthManager())
    }
}

extension SettingsView {
    static let viewTitleText = LocalizedStringKey("SettingsView.Settings")
    static let securitySectionHeaderText = LocalizedStringKey("SettingsView.Security")
    static let securitySectionFooterText = LocalizedStringKey("SettingsView.securitySectionFooter")
    static let localAuthToggleText = LocalizedStringKey("SettingsView.Local Authentication")
    static let biometricsLocalAuthToggleText = LocalizedStringKey("SettingsView.Use Face ID or Touch ID")
    static let passwordAlertTitle = LocalizedStringKey("SettingsView.Password Requested")
    static let passwordAlertMessage = LocalizedStringKey("SettingsView.PasswordAlertMessage")
    static let cancelButton = LocalizedStringKey("SettingsView.Cancel")
    static let passwordCreateButton = LocalizedStringKey("SettingsView.Create")
    static let passwordInput = LocalizedStringKey("SettingsView.Password")
    static let passwordConfirmInput = LocalizedStringKey("SettingsView.Repeat Password")
    static let passwordErrorTitle = LocalizedStringKey("SettingsView.ErrorTitle")
    static let passordErrorButton = LocalizedStringKey("SettingsView.OK")
    static let passwordErrorMessage1 = LocalizedStringKey("SettingsView.ErrorMessage1")
    static let passwordErrorMessage2 = LocalizedStringKey("SettingsView.ErrorMessage2")
    static let passwordErrorMessage3 = LocalizedStringKey("SettingsView.ErrorMessage3")
    static let themeSectionHeaderText = LocalizedStringKey("SettingsView.Theme")
    static let themePickerText = LocalizedStringKey("SettingsView.themePickerText")
    static let userProfileText = LocalizedStringKey("SettingsView.userProfileText")
    static let userNameText = LocalizedStringKey("SettingsView.userNameText")
    static let userPhotoText = LocalizedStringKey("SettingsView.userPhotoText")
    static let permissionError = LocalizedStringKey("SettingsView.PermissionError")
    static let confirmationDialogText = LocalizedStringKey("SettingsView.confirmationDialogText")
    static let cameraText = LocalizedStringKey("SettingsView.cameraText")
    static let photoLibraryText = LocalizedStringKey("SettingsView.photoLibraryText")
    static let openSettingsButtonText = LocalizedStringKey("SettingsView.Open Settings")
    static let cameraError = LocalizedStringKey("SettingsView.CameraError")
    
}
