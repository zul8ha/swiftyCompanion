//
//  AuthManagerMock.swift
//  swifty_companionTests
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

@testable import swifty_companion

class AuthManagerMock: IAuthManager {

    var invokedAccessTokenGetter = false
    var invokedAccessTokenGetterCount = 0
    var stubbedAccessToken: AccessToken!

    var accessToken: AccessToken? {
        invokedAccessTokenGetter = true
        invokedAccessTokenGetterCount += 1
        return stubbedAccessToken
    }

    var invokedAuthStateGetter = false
    var invokedAuthStateGetterCount = 0
    var stubbedAuthState: AuthState!

    var authState: AuthState {
        invokedAuthStateGetter = true
        invokedAuthStateGetterCount += 1
        return stubbedAuthState
    }

    var invokedAuthenticate = false
    var invokedAuthenticateCount = 0
    var stubbedAuthenticateCompletionResult: (Result<AccessToken, Error>, Void)?

    func authenticate(completion: (Result<AccessToken, Error>) -> Void) {
        invokedAuthenticate = true
        invokedAuthenticateCount += 1
        if let result = stubbedAuthenticateCompletionResult {
            completion(result.0)
        }
    }
}
