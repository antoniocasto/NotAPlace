//
//  FileManager.swift
//  MemoroApp
//
//  Created by Antonio Casto on 25/03/23.
//

import Foundation

extension FileManager {
    
    static var documentsDirectory: URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    static func decode<T: Codable>(_ file: String) throws -> T {
        
        // find all possible documents directories for this user
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(file)
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from FileManager.")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from FileManager.")
        }
        
        return loaded
    }

    
}
