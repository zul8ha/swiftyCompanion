//
//  SignInViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/24/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol SignInListener: AnyObject {
    func didSignIn(with accessToken: AccessToken)
}

final class SignInViewController: UIViewController {
    let authHandler = AuthHandler()
    weak var listener: SignInListener?
    var isAuthSessionRunning = false {
        didSet {
            signInButton.isEnabled = !isAuthSessionRunning
            print("💲 isAuthSessionRunning: \(isAuthSessionRunning)")
        }
    }

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 60
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onSignInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.widthAnchor.constraint(equalToConstant: 120),
            signInButton.heightAnchor.constraint(equalToConstant: 120),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func onSignInButtonTapped() {
        
        isAuthSessionRunning = true
        authHandler.showAuthPage(with: self) { [weak self] result in
            self?.handleAuth(result: result)
        }
    }
    
    func handleAuth(result: Result<Token, Error>) {
        DispatchQueue.main.async {
            
            self.isAuthSessionRunning = false
            switch result {
            case let .success(token):
                self.listener?.didSignIn(with: token.access_token)
            case let .failure(error):
                print(error)
            }
        }
    }
}

//MARK: - ASWebAuthenticationPresentationContextProviding

extension SignInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
