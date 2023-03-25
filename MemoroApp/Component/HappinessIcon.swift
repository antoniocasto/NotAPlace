//
//  HappinessIcon.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

struct HappinessIcon: View {
    
    let happinessRate: Location.HappinessRating
    
    var body: some View {
        Image(systemName: happinessRate.ratingIconName)
            .bold()
            .padding()
            .foregroundColor(.white)
            .background(happinessRate.ratingColor)
            .clipShape(Circle())
    }
}

struct HappinessIcon_Previews: PreviewProvider {
    static var previews: some View {
        HappinessIcon(happinessRate: .slightlyHappy)
    }
}
