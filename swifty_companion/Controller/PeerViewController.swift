//
//  PeerViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class PeerViewController: UIViewController {
    
    var httpClient: HTTPClient?
    var login: String?
    var user: User?
    var skills: [Skills] = []
    var projects: [Project] = []
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var userInfo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .top
        return stack
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var userName: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = login
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupTableView()
        httpClient!.loadUserdata(with: login)
        setUpUI()
    }
    
    // MARK: - SET UP UI
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        stackView.backgroundColor = .lightGray
        userInfo.backgroundColor = .darkGray
        tableView.backgroundColor = .gray
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        //        view.addSubview(tableView)
        stackView.addArrangedSubview(peerImage)
        NSLayoutConstraint.activate([
            peerImage.heightAnchor.constraint(equalToConstant: 150),
            peerImage.widthAnchor.constraint(equalTo:  peerImage.heightAnchor, multiplier: 1),
            
        ])
        
        stackView.addArrangedSubview(userInfo)
        userInfo.addArrangedSubview(userName)
        
        NSLayoutConstraint.activate([
            
            //            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            //            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            
        ])
    }
}

