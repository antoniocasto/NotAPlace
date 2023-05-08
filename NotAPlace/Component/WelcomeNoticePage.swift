//
//  WelcomeNoticePage.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 17/04/23.
//

import SwiftUI

struct WelcomeNoticePage: View {
    
    var systemIconName: String?
    var title: LocalizedStringKey = "Title"
    var description: LocalizedStringKey = "Description"
    
    private let imageSize: CGFloat = 80.0
    
    var body: some View {
        VStack {
            
            Spacer()
            Spacer()
            
            if let systemName = systemIconName {
                Circle()
                    .frame(width: imageSize, height: imageSize)
                    .overlay {
                        Image(systemName: systemName)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                    }
            } else {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(Circle())
            }
            
            
                                    
            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)

            
            Spacer()
            Spacer()
            
        }
        .padding()    }
}

struct WelcomeNoticePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeNoticePage()
    }
}
