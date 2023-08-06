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
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case usualFullName = "usual_full_name"
    }
}
