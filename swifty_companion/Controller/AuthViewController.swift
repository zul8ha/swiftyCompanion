//
//  AuthViewController.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 19.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

// https://api.intra.42.fr/oauth/authorize?client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&redirect_uri=https%3A%2F%2Fprofile.intra.42.fr%2F&response_type=code

import UIKit

final class AuthViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 45
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSignInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 90),
            signInButton.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    
    @objc func onSignInButtonTapped() {
        print(#function)
        
    }
}
