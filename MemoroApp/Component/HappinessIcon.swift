//
//  HappinessIcon.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

struct HappinessIcon: View {
    
    let happinessRate: Location.HappinessRating
    var fontSize: CGFloat = 20
    
    var body: some View {
        Image(systemName: happinessRate.ratingIconName)
            .font(.system(size: fontSize))
            .padding(8)
            .foregroundColor(happinessRate.ratingColor)
            .background(.thickMaterial)
            .clipShape(Circle())
    }
}

struct HappinessIcon_Previews: PreviewProvider {
    static var previews: some View {
        HappinessIcon(happinessRate: .veryHappy)
    }
}
