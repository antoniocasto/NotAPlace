//
//  MapPointer.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI

struct MapPointer: View {
    var body: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.3))
            .frame(width: 32, height: 32)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white.opacity(0.7))
            }
    }
}

struct MapPointer_Previews: PreviewProvider {
    static var previews: some View {
        MapPointer()
    }
}
