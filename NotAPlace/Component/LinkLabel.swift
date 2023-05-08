//
//  LinkLabel.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 20/04/23.
//

import SwiftUI

struct LinkLabel: View {
    
    let link: String
    let iconSystemName: String
    let text: String
    
    var body: some View {
        
        Link(destination: URL(string: link)!) {
            HStack {
                
                Image(systemName: iconSystemName)
                
                Text(text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
                                
        }
    }
}

struct LinkLabel_Previews: PreviewProvider {
    static var previews: some View {
        LinkLabel(link: "https://google.com", iconSystemName: "link", text: "Google")
    }
}
