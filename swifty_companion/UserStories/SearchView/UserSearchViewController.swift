//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol UserSearchListener: AnyObject {
    func didSignOut()
}

final class UserSearchViewController: UIViewController {
    
    var accessToken: AccessToken?
    weak var listener: UserSearchListener?
    
    init(accessToken: AccessToken) {
        super.init(nibName: nil, bundle: nil)
        self.accessToken = accessToken
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchField: UITextField = {
        let field = UITextField()
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.backgroundColor = .systemGray6
        field.borderStyle = .roundedRect
        field.placeholder = "Type here the 42peer nickname"
        field.font = .systemFont(ofSize: 12)
        field.autocorrectionType = .no
        
        if let searchParameter = field.text {
            
        }
        
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
        title = "Search User"
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
        view.backgroundColor = .systemBackground
//        navigationController?.setNavigationBarHidden(true, animated: true)

        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.72),
            searchField.heightAnchor.constraint(equalToConstant: 42),
            searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 42),
            searchButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
        addLogOutButton()
    }
    
    func addLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "LogOut",
            style: .plain,
            target: self,
            action: #selector(onBackButtonTap)
        )
    }
    
    @objc func onBackButtonTap() {
        listener?.didSignOut()
        print(#function, "8888")

    }
    
    func showUserDetails(with login: String, token: AccessToken) {
        let httpClient = HTTPClient()
//        let navigationController = UINavigationController()
        let peerViewController = PeerViewController(
            with: httpClient,
            userService: UserService(with: httpClient)
        )
//        navigationController.viewControllers = [peerViewController]

        peerViewController.login = login
        peerViewController.accessToken = token
        
        navigationController?.pushViewController(peerViewController, animated: true)
        //        present(peerViewController, animated: true, completion: nil)
    }
    
    @objc func onButtonTapped() {
        
        guard let login = searchField.text,
            !login.isEmpty,
            let token = accessToken
            else { return }
        showUserDetails(with: login.lowercased(), token: token)
    }
}


