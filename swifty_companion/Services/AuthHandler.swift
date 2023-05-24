//
//  AuthHandler.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/24/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation
import AuthenticationServices

final class AuthHandler {
 
    // MARK: - showAuthPage
    
    var decodedToken: Token?
    var startViewController: StartViewController?
    var signInViewController: SignInViewController?
    
    func showAuthPage() {
        let stringUrl = "https://api.intra.42.fr/oauth/authorize?client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&redirect_uri=hmeriann%3A%2F%2Foauth-callback%2F&response_type=code"
        guard let signInURL = URL(string: stringUrl) else { return }
        let callbackURLScheme = "hmeriann"
        let authenticationSession = ASWebAuthenticationSession(
            url: signInURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            guard
                error == nil,
                let callbackURL = callbackURL,
                // parse the URLComponents from the callbackURL's absolute string
                let urlComponents = URLComponents(string: callbackURL.absoluteString),
                // parse the query items from the URLComponents
                let queryItems = urlComponents.queryItems,
                // get the query item code's value from:
                let code = queryItems.first(where: {$0.name == "code"})?.value
                else { return }
            
            self?.exchangeCodeForTokens(with: code)
        }
        
        print("🚹")

        
        authenticationSession.presentationContextProvider = signInViewController
        //        authenticationSession.prefersEphemeralWebBrowserSession = true
        
        if !authenticationSession.start() {
            print("Failed to start")
        }
    }
    
    func exchangeCodeForTokens(with code: String) {
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
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.extractToken(data: data, response: response, error: error)
        }
        dataTask.resume()
    }
    
    func extractToken(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("🐙Failed to get HTTPURLResponse")
            return
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            print(HTTPClientError.wrongStatusCode)
            print("⏰ httpResponse.statusCode: \(httpResponse.statusCode)")
            return
        }
        guard let data = data else {
            print(HTTPClientError.emptyData)
            return
        }
        
        let decoder = JSONDecoder()
            do {
                decodedToken = try decoder.decode(Token.self, from: data)
                startViewController?.decodedToken = decodedToken
    //            print("☎️ \(decodedToken)")
            } catch {
                print(error.localizedDescription)
            }
    }
    
    
}
