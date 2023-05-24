//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var decodedToken: Token?
    
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
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showAuthPage()
//    }
//
    

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


