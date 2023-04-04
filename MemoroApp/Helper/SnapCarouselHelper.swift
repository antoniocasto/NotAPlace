//
//  SnapCarouselHelper.swift
//  MemoroApp
//
//  Created by Antonio Casto on 04/04/23.
//

import SwiftUI

/*
 Code inspired by a YouTube channel named Kavsoft. Here the link to the tutorial: https://www.youtube.com/watch?v=ZiDVbDlHDF0&list=PLN4ogEDbmrlusyahnhghPBDjei5eU4ANt&index=4
 */

struct SnapCarouselHelper: UIViewRepresentable {
    
    var pageWidth: CGFloat
    var pageCount: Int
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        DispatchQueue.main.async {
            // Get UIScrollView from SwiftUI ScrollView
            // find the correct position in the view tree
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: SnapCarouselHelper
        
        init(parent: SnapCarouselHelper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            // Add velocity in order to make scroll animation perfect
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            
            // Get target index
            let targetIndex = (targetEnd / parent.pageWidth).rounded()
            
            targetContentOffset.pointee.x = targetIndex * parent.pageWidth
            
        }
        
    }
    
}
