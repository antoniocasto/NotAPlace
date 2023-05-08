//
//  SnapCarousel.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 19/04/23.
//

// Code inspired by a YouTube channel named Kavsoft. Here the link to the tutorial: https://www.youtube.com/watch?v=4Gw5lDXJ04g

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState private var dragOffset: CGFloat = .zero
    @State private var currentIndex: Int = 0
        
    init(spacing: CGFloat = 16, trailingSpace: CGFloat = 50, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
        
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            
            // Width adjustment for element between two elements
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            LazyHStack(spacing: spacing) {
                
                ForEach(list) { item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                    
                }
                
            }
            .padding(.horizontal, spacing)
            // Add more offset to center item when index is not zero
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        
                        // Update current index
                        let offsetX = value.translation.width
                        let progress = (-offsetX / width).rounded()
                        
                        currentIndex = max(min(currentIndex + Int(progress), list.count - 1), 0)
                        
                        currentIndex = index
                        
                    }
                    .onChanged { value in
                        
                        // Update current index
                        let offsetX = value.translation.width
                        let progress = (-offsetX / width).rounded()
                        
                        index = max(min(currentIndex + Int(progress), list.count - 1), 0)
                        
                        
                    }
                    
            )
            
        }
        .animation(.easeInOut, value: dragOffset == 0)
        
    }
}
