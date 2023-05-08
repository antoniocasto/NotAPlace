//
//  SearchBar.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 19/04/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var searchActive: Bool
    
    var body: some View {
        
        HStack {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField(SearchBar.searchPrompt, text: $searchText)
                    
            }
            .padding(8)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .onTapGesture {
                withAnimation {
                    searchActive = true
                }
            }
            
            if searchActive {
                
                Button(SearchBar.cancelButtonText) {
                    
                    searchText = ""
                    
                    withAnimation {
                        searchActive = false
                    }
                    
                    hideKeyboard()
                    
                }
                
            }
            
        }
        
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), searchActive: .constant(true))
            .padding()
    }
}

extension SearchBar {
    static let searchPrompt = LocalizedStringKey("SearchBar.searchPrompt")
    static let cancelButtonText = LocalizedStringKey("SearchBar.cancelButtonText")
}
