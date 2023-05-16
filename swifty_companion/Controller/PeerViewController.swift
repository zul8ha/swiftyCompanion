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
    var skills: [Skill] = []
    var projects: [Project] = []
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var userInfo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var userName: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = user?.login
        return label
    }()
    
    private lazy var userFullName: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.setContentCompressionResistancePriority(UILayoutPriority(740), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(240), for: .horizontal)
        label.text = user?.displayName
        return label
    }()
    
    private lazy var email: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.setContentCompressionResistancePriority(UILayoutPriority(720), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(220), for: .horizontal)
        
        label.text = user?.email
        return label
    }()
    
    private lazy var wallets: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
//        label.setContentCompressionResistancePriority(UILayoutPriority(740), for: .horizontal)
//        label.setContentHuggingPriority(UILayoutPriority(240), for: .horizontal)
        label.text = "xxx"
        return label
    }()
    
    private lazy var poolYear: UILabel = {
         
         let label = UILabel()
         
         label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
//        label.setContentCompressionResistancePriority(UILayoutPriority(740), for: .horizontal)
//        label.setContentHuggingPriority(UILayoutPriority(240), for: .horizontal)
         label.text = "xxx"
         return label
     }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = UITableView.automaticDimension
        
        table.dataSource = self
        table.delegate = self
        table.register(SkillTableViewCell.self, forCellReuseIdentifier: "skillCell")
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: "projectCell")

        return table
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUserdata(with: login)
        setUpUI()
        self.tableView.reloadData()
    }
    
    // MARK: - loadUserdata
    
    func loadUserdata(with login: String?) {
        
        guard let login = login else { return }
        // curl  -H "Authorization: Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b" "https://api.intra.42.fr/v2/users/ccade"
        if let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") {
            var urlRequest = URLRequest(url: url)
            let bearer = "Bearer 6185c1bff9ab376fe8ab31ec06f860997309a939a60d75f91c52480df0bdf69a"
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
        //        guard let user = user else { return }
        userName.text = user.login
        userFullName.text = user.displayName
        email.text = user.email
        wallets.text = "Wallet: ₳ \(user.wallet)"
        poolYear.text = "Pool Year: \(user.poolYear)"
        
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
    
    // MARK: - SET UP UI
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
        ])
        
        stackView.addArrangedSubview(peerImage)
        NSLayoutConstraint.activate([
            peerImage.heightAnchor.constraint(equalToConstant: 150),
            peerImage.widthAnchor.constraint(equalTo:  peerImage.heightAnchor, multiplier: 1),
            
        ])
        stackView.addArrangedSubview(userInfo)
        
        userInfo.addArrangedSubview(userName)
        userInfo.addArrangedSubview(userFullName)
        userInfo.addArrangedSubview(email)
        userInfo.addArrangedSubview(poolYear)
        userInfo.addArrangedSubview(wallets)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
}

// MARK: - TABLE VIEW

enum UserDescriptionSection: CaseIterable {
    
    case skills
    case projects
    
    var sectionIndex: Int {
        switch self {
        case .skills:
            return 0
        case .projects:
            return 1
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .skills:
            return "Skills"
        case .projects:
            return "Projects"
        }
    }
}

extension PeerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserDescriptionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case UserDescriptionSection.skills.sectionIndex:
            return UserDescriptionSection.skills.sectionTitle
        case UserDescriptionSection.projects.sectionIndex:
            return UserDescriptionSection.projects.sectionTitle
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let user = user else {return 0}
        switch section {
        case UserDescriptionSection.skills.sectionIndex:
            return skills.count
        case UserDescriptionSection.projects.sectionIndex:
            return projects.count
        default:
            return 0
        }
    }
}

extension PeerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let user = user else { return UITableViewCell() }
        switch indexPath.section {
        case UserDescriptionSection.skills.sectionIndex:
            let skill = skills[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillTableViewCell else { return UITableViewCell() }
            cell.configure(with: skill)
            return cell
        case UserDescriptionSection.projects.sectionIndex:
            let project = projects[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
            cell.configure(with: project)
            return cell
        default:
            return UITableViewCell()
        
        }
        

    }
}
