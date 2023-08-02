//
//  KeyValueStorage.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol IKeyValueStorage {
    func set(_ value: String, for key: String)
    
    func get(valueFor key: String) -> String?
    
    func removeAllValues()
}

/// To store the access token in the sictionary
final class KeyValueStorageNaive: IKeyValueStorage {

    private var dictionary = [String: String]()
    
    func set(_ value: String, for key: String) {
        dictionary[key] = value
    }
    
    func get(valueFor key: String) -> String? {
        dictionary[key]
    }

    func removeAllValues() {
        dictionary.removeAll()
    }
}

/// To store acces token in UserDefaults
final class KeyValueStorage: IKeyValueStorage {
    
    private let userDefaults = UserDefaults.standard
    
    func set(_ value: String, for key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func get(valueFor key: String) -> String? {
        userDefaults.string(forKey: key)
    }
    
    func removeAllValues() {
        userDefaults.removeObject(forKey: "accessToken")
        userDefaults.removeObject(forKey: "refreshToken")
    }
}
