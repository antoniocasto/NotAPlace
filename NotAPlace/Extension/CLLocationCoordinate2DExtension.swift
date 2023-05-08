//
//  CLLocationCoordinate2DExtension.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 20/03/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}
