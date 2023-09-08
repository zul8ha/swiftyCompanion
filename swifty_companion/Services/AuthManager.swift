//
//  AuthManager.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import AuthenticationServices

// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/token

typealias AccessToken = String

enum AuthState {
    case authorised(accessToken: AccessToken)
    case unauthorised
}

//protocol AuthManagerDelegate {
//    func showError(
//}

protocol IAuthManager {
    var authState: AuthState { get }
    
    func showAuthPage(
        with authContentProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (Result<AccessToken, Error>) -> Void
    )
    
    func logOut()
}

/// The purpose of the class AuthManager is to get an Access Token
/// First it shows thisrd-part Authorisation page using ASWebAuthenticationPresentationContextProviding to login the user, handles callback, exchanges a code to an access token and saves it to the UserDefaults.
/// It is possible to remove token data from UserDefaults calling logOut() from the instance of the authManager.
final class AuthManager: IAuthManager {
// "https://api.intra.42.fr/oauth/authorize?client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&redirect_uri=hmeriann%3A%2F%2Foauth-callback%2F&response_type=code"
    
    // MARK: Static properties
    
//    static let clientId = "fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29"
//    static let clientSecret = "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"
    
    static let callbackURLScheme = "hmeriann"
    static let clientId = ProcessInfo.processInfo.environment["UID"] ?? nil
    static let clientSecret = ProcessInfo.processInfo.environment["SECRET"] ?? nil
        
    /// Builds a OAuth URL from the components
    /// - Returns: URL
    static func makeOAuthUrl() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.intra.42.fr"
        urlComponents.path = "/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: "hmeriann://oauth-callback/"),
            URLQueryItem(name: "response_type", value: "code")
        ]
        guard let url = urlComponents.url else {
            fatalError("Cannot construct OAuth URL")
        }
        return url
    }
    
    /// Builds a URLRequest from url, which built from String query items using URLComponents
    /// - Parameter code: will be exchanged to an access token later, when perform the request
    /// - Returns: URLRequest
    static func makeCodeExchangeRequest(code: String) -> URLRequest {
    
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.intra.42.fr"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: AuthManager.clientId),
            URLQueryItem(name: "client_secret", value: AuthManager.clientSecret),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "hmeriann://oauth-callback/")
        ]
        guard let url = urlComponents.url else {
            fatalError("Cannot create exchange URL")
        }
        //        print("👻", url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
// MARK: Internal properties
    
    let keyValueStorage: IKeyValueStorage
    
    init(
        keyValueStorage: IKeyValueStorage
    ) {
        self.keyValueStorage = keyValueStorage
    }
    
    /// Need to be known that doesn't show the SignInVC, if there is an access token already saved
    private var accessToken: AccessToken?
    var authState: AuthState {
        if let accessToken = keyValueStorage.get(valueFor: "accessToken") {
            
//        if let accessToken = accessToken {
            return .authorised(accessToken: accessToken)
        }
        return .unauthorised
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - authContentProvider: <#authContentProvider description#>
    ///   - completion: <#completion description#>
    func showAuthPage(
        with authContentProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (Result<AccessToken, Error>) -> Void
    ) {
        let authUrl = AuthManager.makeOAuthUrl()
        let authenticationSession = ASWebAuthenticationSession(
            url: authUrl,
            callbackURLScheme: AuthManager.callbackURLScheme
        ) { [weak self] callbackUrl, error in
            self?.handleAuthCallback(callbackUrl: callbackUrl, error: error, completion: completion)
        }
        authenticationSession.presentationContextProvider = authContentProvider
        if !authenticationSession.start() {
            completion(.failure(AuthError.failedToStartAuthSession))
        }
    }
    
    /// handleAuthCallback - extracts the exchange code from the callBackUrl
    func handleAuthCallback(
        callbackUrl: URL?,
        error: Error?,
        completion: @escaping (Result<AccessToken, Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(AuthError.showAuthPageError(error)))
        }
        guard
            let callbackUrl = callbackUrl,
            // parse the URLComponents from the callbackURL's absolute string
            let urlComponents = URLComponents(string: callbackUrl.absoluteString),
            // parse the query items from the URLComponents
            let queryItems = urlComponents.queryItems,
            // get the query item code's value from:
            let code = queryItems.first(where: {$0.name == "code"})?.value
        else {
            completion(.failure(AuthError.showAuthPageError(nil)))
            return
        }
        
        exchangeCodeForTokens(with: code, completion: completion)
    }
    
    func exchangeCodeForTokens(
        with code: String,
        completion: @escaping (Result<AccessToken, Error>) -> Void
    ) {
        let exchangeRequest = AuthManager.makeCodeExchangeRequest(code: code)
        
        let dataTask = URLSession.shared.dataTask(with: exchangeRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let result = self.extractToken(data: data, response: response, error: error)
            switch result {
            case let .success(token):
                completion(.success(token.accessToken))
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func extractToken(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<Token, Error> {
        
        if let error = error {
            print(error.localizedDescription)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(AuthError.wrongResponseType)
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            return .failure(AuthError.wrongStatusCode)
        }
        guard let data = data else {
            return .failure(AuthError.emptyData)
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedToken = try decoder.decode(Token.self, from: data)
//            self.accessToken = decodedToken
            save(decodedToken)
            return .success(decodedToken)
        } catch {
            return .failure(AuthError.decodingError(error))
        }
    }
    
    func save(_ token: Token) {
        keyValueStorage.set(token.accessToken, for: "accessToken")
        keyValueStorage.set(token.refreshToken, for: "refreshToken")
//        keyValueStorage.set(token.expiresIn, for: "expiresIn")
//        accessToken = token.accessToken
    }
    
    func logOut() {
        keyValueStorage.removeAllValues()
    }
}
