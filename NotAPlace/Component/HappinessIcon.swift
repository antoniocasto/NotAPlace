//
//  HappinessIcon.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

struct HappinessIcon: View {
    
    let happinessRate: Location.HappinessRating
    var fontSize: CGFloat = 20
    
    var body: some View {
        Text(happinessRate.ratingEmoji)
            .font(.system(size: fontSize))
            .padding(8)
            .background(.thickMaterial)
            .clipShape(Circle())
    }
}

struct HappinessIcon_Previews: PreviewProvider {
    static var previews: some View {
        HappinessIcon(happinessRate: .veryHappy)
    }
}
