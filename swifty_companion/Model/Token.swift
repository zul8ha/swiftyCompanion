//
//  Token.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 20.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

struct Token: Decodable {
    var access_token: String
    var token_type: String
    var expires_in: Int
    var scope: String
    var created_at: Int
}
