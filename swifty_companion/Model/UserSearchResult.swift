//
//  UserSearchResult.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 06.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

struct UserSearchResult: Codable {
    let id: Int
    let login: String
    let usualFullName: String
    let kind: String
    let image: Image?
    let active: Bool
    let alumni: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case usualFullName = "usual_full_name"
        case kind
        case image
        case active = "active?"
        case alumni = "alumni?"
    }
    
    struct Image: Codable {
        let link: String?
    }
}
