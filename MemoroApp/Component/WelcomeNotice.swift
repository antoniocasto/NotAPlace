//
//  WelcomeNotice.swift
//  MemoroApp
//
//  Created by Antonio Casto on 17/04/23.
//

import SwiftUI

struct WelcomeNotice: View {
    
    @Binding var showWelcomeNotice: Bool
        
    private let imageSize: CGFloat = 80
    
    @State private var showElements = false
    
    var body: some View {
        GeometryReader { proxy in
            
            let screenWidth = proxy.size.width
            let screenHeight = proxy.size.height
            
            if showElements {
                ZStack {
                    
                    TabView {
                        pageOne
                        pageTwo
                        pageThree
                        pageFour
                        pageFive
                    }
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .tabViewStyle(.page)
                    .frame(width: screenWidth - 64, height: screenHeight / 1.8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 10, y: 10)
                    .overlay(alignment: .topTrailing) {
                        closeButton
                    }
                    
                }
                .frame(width: screenWidth, height: screenHeight)
                .background(.ultraThinMaterial)
            }
        }
        .animation(.easeInOut, value: showElements)
        .onAppear {
            showElements = true
        }
        
    }
    
    var pageOne: some View {
        WelcomeNoticePage(title: WelcomeNotice.pageOneTitle, description: WelcomeNotice.pageOneDescription)
    }
    
    var pageTwo: some View {
        WelcomeNoticePage(systemIconName: "lock", title: WelcomeNotice.pageTwoTitle, description: WelcomeNotice.pageTwoDescription)
    }
    
    var pageThree: some View {
        WelcomeNoticePage(systemIconName: "map", title: WelcomeNotice.pageThreeTitle, description: WelcomeNotice.pageThreeDescription)
    }
    
    var pageFour: some View {
        WelcomeNoticePage(systemIconName: "house", title: WelcomeNotice.pageFourTitle, description: WelcomeNotice.pageFourDescription)
    }
    
    var pageFive: some View {
        WelcomeNoticePage(systemIconName: "paintpalette", title: WelcomeNotice.pageFiveTitle, description: WelcomeNotice.pageFiveDescription)
    }
    
    var closeButton: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.largeTitle)
            .foregroundColor(.secondary)
            .padding()
            .onTapGesture {
                showElements = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showWelcomeNotice = false
                }
            }
    }
    
}

struct WelcomeNotice_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeNotice(showWelcomeNotice: .constant(true))
    }
}
extension WelcomeNotice {
    static let pageOneTitle = LocalizedStringKey("WelcomeNotice.pageOneTitle")
    static let pageOneDescription = LocalizedStringKey("WelcomeNotice.pageOneDescription")
    static let pageTwoTitle = LocalizedStringKey("WelcomeNotice.pageTwoTitle")
    static let pageTwoDescription = LocalizedStringKey("WelcomeNotice.pageTwoDescription")
    static let pageThreeTitle = LocalizedStringKey("WelcomeNotice.pageThreeTitle")
    static let pageThreeDescription = LocalizedStringKey("WelcomeNotice.pageThreeDescription")
    static let pageFourTitle = LocalizedStringKey("WelcomeNotice.pageFourTitle")
    static let pageFourDescription = LocalizedStringKey("WelcomeNotice.pageFourDescription")
    static let pageFiveTitle = LocalizedStringKey("WelcomeNotice.pageFiveTitle")
    static let pageFiveDescription = LocalizedStringKey("WelcomeNotice.pageFiveDescription")
}
