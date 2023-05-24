//
//  SignInViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/24/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    
    
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
//        showAuthPage()
        
        let startViewController = StartViewController()
        navigationController?.pushViewController(startViewController, animated: true)
//        self.present(startViewController, animated: true, completion: nil)
//        self.show(startViewController, sender: self)
    }
    
}
