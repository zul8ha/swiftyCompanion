//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

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
        field.borderStyle = .roundedRect
        field.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .horizontal)
        field.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 700), for: .horizontal)
        
        return field
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Zoek", for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8 ),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8 ),
        ])
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(searchButton)
    }

    func showUserDetails(with login: String) {
        let httpClient = HTTPClient()
        let peerViewController = PeerViewController(
            with: httpClient,
            userService: UserService(with: httpClient)
        )
        peerViewController.login = login
        
        navigationController?.pushViewController(peerViewController, animated: true)
//        present(peerViewController, animated: true, completion: nil)
    }
    
    @objc func onButtonTapped() {
        
        guard let login = searchField.text, !login.isEmpty else { return }
        
        showUserDetails(with: login.lowercased())
    }
    
}

