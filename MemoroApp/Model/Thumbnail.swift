//
//  Thumbnail.swift
//  MemoroApp
//
//  Created by Antonio Casto on 05/04/23.
//

import SwiftUI

struct Thumbnail: Identifiable {
    var id = UUID()
    let image: UIImage
    let isMap: Bool
}
