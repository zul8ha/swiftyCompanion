//
//  SignInViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/24/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController {
    let authHandler = AuthHandler()

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
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.widthAnchor.constraint(equalToConstant: 120),
            signInButton.heightAnchor.constraint(equalToConstant: 120),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func onSignInButtonTapped() {
        
//        let authHandler = AuthHandler()
        authHandler.showAuthPage(with: self) { result in
            
            
        }
        
//        if authHandler.decodedToken == nil {
//            print("📸📸📸📸📸📸 - EMPTY TOKEN")
//        } else {
//            let startViewController = StartViewController()
//            navigationController?.pushViewController(startViewController, animated: true)
//        }
        
        
//        self.present(startViewController, animated: true, completion: nil)
//        self.show(startViewController, sender: self)
    }
    
}

//MARK: - ASWebAuthenticationPresentationContextProviding

extension SignInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
