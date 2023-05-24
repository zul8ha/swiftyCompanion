//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit
import AuthenticationServices

class StartViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var searchField: UITextField = {
        let field = UITextField()
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.backgroundColor = .systemGray6
        field.borderStyle = .roundedRect
        field.placeholder = "Type here the 42peer nickname"
        field.font = .systemFont(ofSize: 12)
        //        field.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .horizontal)
        //        field.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 700), for: .horizontal)
        
        return field
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitle("Zoek", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAuthPage()
    }
    
    
    // MARK: - showAuthPage
    
    var decodedToken: Token?
    
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
        
        authenticationSession.presentationContextProvider = self
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
    //            print("☎️ \(decodedToken)")
            } catch {
                print(error.localizedDescription)
            }
    }
    
    // MARK: - setUpUI
    func setUpUI() {
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: true)   
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8 ),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8 ),
        ])
        stackView.addArrangedSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.78)
        ])
        stackView.addArrangedSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    func showUserDetails(with login: String, token: Token) {
        let httpClient = HTTPClient()
//        let navigationController = UINavigationController()
        let peerViewController = PeerViewController(
            with: httpClient,
            userService: UserService(with: httpClient)
        )
//        navigationController.viewControllers = [peerViewController]

        peerViewController.login = login
        peerViewController.token = token
        
        navigationController?.pushViewController(peerViewController, animated: true)
        //        present(peerViewController, animated: true, completion: nil)
    }
    
    @objc func onButtonTapped() {
        
        guard let login = searchField.text,
            !login.isEmpty,
            let token = decodedToken
            else { return }
        showUserDetails(with: login.lowercased(), token: token)
    }
}

//MARK: - ASWebAuthenticationPresentationContextProviding

extension StartViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
