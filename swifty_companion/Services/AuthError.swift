//
//  AuthError.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 27.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case showAuthPageError(Error?) // couldn't get the code
    case wrongResponseType
    case wrongStatusCode
    case emptyData
    case decodingError(Error)
    case failedToStartAuthSession
    
    var errorMessage: String {
        switch self {
        case let .showAuthPageError(error):
            return "\(error?.localizedDescription ?? "Error"): Couldn't get the code."
        case .wrongResponseType:
            return "Wrong Response Type"
        case .wrongStatusCode:
            return "Wrong Status Code"
        case .emptyData:
            return "Empty Data"
        case let .decodingError(error):
            return "Decoding Error: \(error.localizedDescription)"
        case .failedToStartAuthSession:
            return "Failed To Start Authorisation Session"
        }
    }

}
