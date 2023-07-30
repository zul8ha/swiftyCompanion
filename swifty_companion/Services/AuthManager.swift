//
//  AuthManager.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/token

typealias AccessToken = String

enum AuthState {
    case authorised(accessToken: AccessToken)
    case unauthorised
}

protocol IAuthManager {
    var accessToken: AccessToken? { get }
    var authState: AuthState { get }
    
    func authenticate(completion: (Result<AccessToken, Error>) -> Void)
}

final class AuthManager: IAuthManager {
    var authState: AuthState {
        if let accessToken = accessToken {
            return .authorised(accessToken: accessToken)
        }
        return .unauthorised
    }
    
    var accessToken: String?
    
    func authenticate(completion: (Result<AccessToken, Error>) -> Void) {
        
    }
    
    
}
