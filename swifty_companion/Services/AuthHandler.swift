//
//  AuthHandler.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/24/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation
import AuthenticationServices

protocol IAuthHandler {
    func showAuthPage(
        with authContentProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (Result<Token, Error>) -> Void
    )
}

enum AuthError: Error {
    case showAuthPageError(Error?) // couldn't get the code
    case wrongResponseType
    case wrongStatusCode
    case emptyData
    case decodingError(Error)
}
///
final class AuthHandler: IAuthHandler {
 
    // MARK: - showAuthPage
    
    var decodedToken: Token?
    var startViewController: UserSearchViewController?
    
    
    func showAuthPage(
        with authContentProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (Result<Token, Error>) -> Void
    ) {
        let stringUrl = "https://api.intra.42.fr/oauth/authorize?client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&redirect_uri=hmeriann%3A%2F%2Foauth-callback%2F&response_type=code"
        guard let signInURL = URL(string: stringUrl) else { return }
        let callbackURLScheme = "hmeriann"
        let authenticationSession = ASWebAuthenticationSession(
            url: signInURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            
            if let error {
                completion(.failure(AuthError.showAuthPageError(error)))
            }
            
            guard
                let callbackURL = callbackURL,
                // parse the URLComponents from the callbackURL's absolute string
                let urlComponents = URLComponents(string: callbackURL.absoluteString),
                // parse the query items from the URLComponents
                let queryItems = urlComponents.queryItems,
                // get the query item code's value from:
                let code = queryItems.first(where: {$0.name == "code"})?.value
                else {
                    completion(.failure(AuthError.showAuthPageError(nil)))
                    return
            }
            
            self?.exchangeCodeForTokens(with: code, completion: completion)
        }
                
        authenticationSession.presentationContextProvider = authContentProvider
//        authenticationSession.prefersEphemeralWebBrowserSession = true
        
        if !authenticationSession.start() {
            print("Failed to start")
        }
    }
    
    func exchangeCodeForTokens(
        with code: String,
        completion: @escaping (Result<Token, Error>) -> Void
    ) {
        print("😶‍🌫️", #function, code)
        let clientId = "fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29"
        let clientSecret = "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"
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.intra.42.fr"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "hmeriann://oauth-callback/")
        ]
        guard let url = urlComponents.url else { return }
        print("👻", url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            let result = self.extractToken(data: data, response: response, error: error)
            completion(result)
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
                self.decodedToken = decodedToken
                return .success(decodedToken)
            } catch {
                return .failure(AuthError.decodingError(error))
            }
    }
    
    
}
