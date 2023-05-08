//
//  KeychainHelper.swift
//  NotAPlaceApp
//
//  Created by Antonio Casto on 20/03/23.
//

import Foundation
import AuthenticationServices

struct KeychainHelper {
        
    // Add an item in Keychain
    static func save(_ data: Data, service: String, account: String) {
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [CFString : Any] as CFDictionary
            
        let saveStatus = SecItemAdd(query, nil)
     
        if saveStatus != errSecSuccess {
            print("Error: \(saveStatus)")
        }
        
        if saveStatus == errSecDuplicateItem {
            update(data, service: service, account: account)
        }
        
    }
    
    // Update an item in Keychain
    static func update(_ data: Data, service: String, account: String) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [CFString : Any] as CFDictionary
            
        let updatedData = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, updatedData)
        
    }
    
    // Read in item from Keychain
    static func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
            
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }
    
}
