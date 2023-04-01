//
//  ViewExtension.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension View {
    func cornerRadius(_ radius: Int, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(cornerRadius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var cornerRadius: Int
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        return Path(path.cgPath)
    }
    
}
