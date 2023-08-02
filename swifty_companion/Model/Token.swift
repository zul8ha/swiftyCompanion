//
//  Token.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 20.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

struct Token: Decodable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var refreshToken: String
    var scope: String
    var createdAt: Int
    
    func getAccessToken() -> String {
        return accessToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
    }
}
