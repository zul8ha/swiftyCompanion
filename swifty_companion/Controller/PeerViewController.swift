//
//  PeerViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class PeerViewController: UIViewController {
    
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
        //        stack.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        //        stack.setContentCompressionResistancePriority(UILayoutPriority(<#T##rawValue: Float##Float#>), for: <#T##NSLayoutConstraint.Axis#>)
        return stack
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFit
        
        //        image.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        //        image.setContentCompressionResistancePriority(<#T##priority: UILayoutPriority##UILayoutPriority#>, for: <#T##NSLayoutConstraint.Axis#>)
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
        loadUserdata(with: login)
        setUpUI()
    }
    
    
  
    
    // MARK:- SHOW USER
    
    func parseUserForSkills(for user: User) {
        for cursus in user.cursusUsers {
            for skill in cursus.skills {
                skills.append(skill)
            }
        }
    }
    
    func showUser(_ user: User) {
        userName.text = user.login
        
        if let imageLink = user.image?.link {
            loadImage(with: imageLink)
        }
    }
    
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadImage(with imageURLString: String) {
        guard let url = URL(string: imageURLString) else { return }
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let data = data,
                    !data.isEmpty,
                    let image = UIImage(data: data) {
                    self.peerImage.image = image
                }
            }
        }
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    // MARK:- SET UP UI
    
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

