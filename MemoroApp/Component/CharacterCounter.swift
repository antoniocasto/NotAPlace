//
//  CharacterCounter.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI

struct CharacterCounter: View {
    
    let text: String
    let charLimit: Int
    
    var body: some View {
        VStack(alignment: .trailing) {
            Divider()
            
            Group{
                Text("\(text.count)/\(charLimit) ") + Text(AddPlaceView.titleMaxChar)
            }
                .foregroundColor(text.count == charLimit ? Color.red : Color.gray)
                .font(.caption)
        }.listRowBackground(Color.clear)
    }
}

struct CharacterCounter_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCounter(text: "AAAA", charLimit: 50)
    }
}
