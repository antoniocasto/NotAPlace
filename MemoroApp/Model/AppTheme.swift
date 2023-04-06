//
//  AppTheme.swift
//  MemoroApp
//
//  Created by Antonio Casto on 29/03/23.
//

import SwiftUI

enum AppTheme: Int, CaseIterable {
        
    case systemBased, darkMode, lightMode
    
    var themeName: LocalizedStringKey {
        switch self {
        case .systemBased:
            return AppTheme.systemBasedText
        case .lightMode:
            return AppTheme.lightThemeText
        case .darkMode:
            return AppTheme.darkThemeText
        }
    }
    
    var themeScheme: ColorScheme? {
        switch self {
        case .systemBased:
            return nil
        case .darkMode:
            return .dark
        case .lightMode:
            return .light
        }
    }
    
    var accentColor: Color {
        switch self {
        case .systemBased:
            return Color.accentColor
        case .darkMode:
            return .darkAccentColor
        case .lightMode:
            return .lightAccentColor
        }
    }
    
}

extension AppTheme {
    static let systemBasedText = LocalizedStringKey("AppTheme.systemBasedText")
    static let lightThemeText = LocalizedStringKey("AppTheme.lightThemeText")
    static let darkThemeText = LocalizedStringKey("AppTheme.darkThemeText")
}
