//
//  AddPlaceView.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI
import MapKit

struct AddPlaceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var pickedImage: UIImage?
    
    let region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    let charLimit = 50
    
    @State private var title = ""
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { proxy in
                
                Form {
                    
                    Section {
                        ZStack {
                            Map(coordinateRegion: .constant(region), showsUserLocation: true)
                                .frame(maxWidth: .infinity)
                                .frame(height: proxy.size.height / 3)
                                .cornerRadius(10)
                                .disabled(true)
                            
                            MapPointer()
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                    
                    Section(AddPlaceView.placeTitleSection) {
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            Image(systemName: "character")
                                .foregroundColor(.accentColor)
                            
                            
                            VStack {
                                
                                TextField(AddPlaceView.placeTitleSection, text: $title)
                                    .onChange(of: title) { newValue in
                                        if newValue.count > charLimit {
                                            title = String(newValue.prefix(charLimit))
                                        }
                                    }
                                
                                CharacterCounter(text: title, charLimit: charLimit)
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    Section("Place image") {
                        
                        HStack {
                            
                            ZStack {
                                if let image = pickedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width / 4, height: proxy.size.height / 8)
                                        .cornerRadius(10)
                                }
                            }
                            
                            
                            Button(pickedImage == nil ? "Pick image" : "Change image") {
                                withAnimation {
                                    pickedImage = UIImage(imageLiteralResourceName: "Logo")
                                }
                                
                                
                            }
                            .bold()
                            .foregroundColor(Color.accentColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .animation(.default, value: pickedImage)
                        
                    }
                    
                    
                }
                
                
            }
            .navigationTitle(AddPlaceView.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .tint(.accentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                        // Save new place here
                        
                        
                    } label: {
                        Text("Save").bold()
                    }
                    .tint(.accentColor)
                    
                }
                
            }
        }
    }
    
    
    
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}

extension AddPlaceView {
    static let navigationTitle = LocalizedStringKey("AddPlaceView.NewPlace")
    static let placeTitleSection = LocalizedStringKey("AddPlaceView.PlaceTitleSection")
    static let titleMaxChar = LocalizedStringKey("AddPlaceView.TitleMaxChar")
}
