//
//  ViewPlaceHolder.swift
//  MemoroApp
//
//  Created by Antonio Casto on 20/04/23.
//

import SwiftUI

struct ViewPlaceholder<Content: View>: View {
    
    var iconSystemName: String
    var text: LocalizedStringKey
    var content: () -> Content
    
    init(iconSystemName: String, text: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.iconSystemName = iconSystemName
        self.text = text
        self.content = content
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Image(systemName: iconSystemName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(text)
                .font(.title2.bold())
                .padding(8)
            
            content()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ViewPlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        ViewPlaceholder(iconSystemName: "pencil", text: "Hello") {
            Text("Injected component")
        }
    }
}
