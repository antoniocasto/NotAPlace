//
//  Location.swift
//  MemoroApp
//
//  Created by Antonio Casto on 21/03/23.
//

import SwiftUI
import CoreLocation

struct Location: Identifiable, Codable {
    
    var id = UUID()
    let title: String
    let description: String
    let image: String
    let emotionalRating: EmotionalRating
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var ratingIconName: String {
        switch emotionalRating {
        case .slightlyHappy:
            return "hand.thumbsup"
        case .happy:
            return "face.smiling"
        case .veryHappy:
            return "heart"
        }
    }
    
    var ratingColor: Color {
        switch emotionalRating {
        case .slightlyHappy:
            return .gray
        case .happy:
            return .yellow
        case .veryHappy:
            return .red
        }
    }
    
    enum EmotionalRating: Int, Codable {
        case slightlyHappy = 0
        case happy = 1
        case veryHappy = 2
    }
}
