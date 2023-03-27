//
//  Location.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI
import CoreLocation

struct Location: Identifiable, Codable, Hashable {
    
    var id = UUID()
    var title: String
    var description: String
    var image: String?
    var emotionalRating: HappinessRating
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum HappinessRating: Int, Codable, CaseIterable {
        case slightlyHappy = 0
        case happy = 1
        case veryHappy = 2
        
        var ratingIconName: String {
            switch self {
            case .slightlyHappy:
                return "hand.thumbsup"
            case .happy:
                return "face.smiling"
            case .veryHappy:
                return "heart"
            }
        }
        
        var ratingColor: Color {
            switch self {
            case .slightlyHappy:
                return .gray
            case .happy:
                return .yellow
            case .veryHappy:
                return .red
            }
        }
        
    }
    
    static let example = Location(title: "Place 1", description: "", emotionalRating: .happy, latitude: -10, longitude: 10)
}
