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
        
        return stack
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        return image
    }()
    
    private lazy var label: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = login
        return label
    }()
    
    // TODO show login in the label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupTableView()
        loadUserdata(with: login)
        setUpUI()
    }
    
    // MARK: - loadUserdata
    
    func loadUserdata(with login: String?) {
        
        guard let login = login else { return }
        // curl  -H "Authorization: Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b" "https://api.intra.42.fr/v2/users/ccade"
        if let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") {
            var urlRequest = URLRequest(url: url)
            let bearer = "Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b"
            urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
            
            let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
                guard let self = self else { return }
                self.handleResult(data: data, response: response, error: error)
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler)
            dataTask.resume()
        }
    }
    
    func handleResult(data: Data?, response: URLResponse?, error: Error?) {
        if (error != nil) {
            showError(error!.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            showError("Wrong response type")
            return
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            showError("Wrong status type: \(httpResponse.statusCode)")
            return
        }
        
        guard let data = data else {
            showError("Empty data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedUser = try decoder.decode(User.self, from: data)
            DispatchQueue.main.async {
                self.user = decodedUser
                
                self.showUser(decodedUser)
                
            }
        } catch {
            showError("Decoding Error: \(error)")
            print(String(bytes: data, encoding: .utf8)!)
        }
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
        label.text = user.login
        
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
        let urlRequest = URLRequest(url: url)
        
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
        view.addSubview(peerImage)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            peerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            peerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: peerImage.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
    }
}

// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/token

// curl  -H "Authorization: Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b" "https://api.intra.42.fr/v2/users/ccade"
