//
//  PeerViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/accessToken


import UIKit

class PeerViewController: UIViewController {
    
    var login: String?
    var user: User?
    var accessToken: AccessToken?
    var skills: [Skill] = []
    var projects: [Project] = []
    private let httpClient: IHTTPClient
    private let userService: IUserService
    
    // MARK: - init
    init(with httpClient: IHTTPClient, userService: IUserService) {
        self.httpClient = httpClient
        self.userService = UserService(with: httpClient)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.tintColor = .darkGray
        image.setContentHuggingPriority(UILayoutPriority(900), for: .horizontal)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var userInfo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    private lazy var userFullName: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.setContentCompressionResistancePriority(UILayoutPriority(740), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(240), for: .horizontal)
        label.numberOfLines = 0
        label.text = user?.displayName
        return label
    }()
    
    private lazy var email: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.setContentCompressionResistancePriority(UILayoutPriority(720), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(220), for: .horizontal)
        label.numberOfLines = 0
        label.text = user?.email
        return label
    }()
    
    private lazy var wallets: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private lazy var poolYear: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private lazy var userLevel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = ""
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
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
        
        setUpUI()
        // to show it as a title of the View - on the NavigationBar (the same as navigationItem.title = login)
        title = login
        guard let login = login else { return }
        loadUserData(with: login)
    }
    
    // MARK: - Load User Data
    
    func loadUserData(with login: String) {
        guard let accessToken = accessToken else { return }
        userService.loadUserData(with: login, accessToken: accessToken, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.handleUserLoading(with: result)
            }
        })
    }
    
    func handleUserLoading(with result: Result<User, Error>) {
        switch result {
        case let .success(user):
            self.user = user
            parseUserForSkills(for: user)
            showUser(user)
            tableView.reloadData()
        case let .failure(error):
            showError(error.localizedDescription)
        }
    }
    
    // MARK: - Show User
    
    func parseUserForSkills(for user: User) {
        for cursus in user.cursusUsers {
            for skill in cursus.skills {
                skills.append(skill)
            }
        }
    }
    
    func showUser(_ user: User) {
        userFullName.text = user.displayName
        email.text = user.email
        wallets.text = "Wallet: ₳ \(user.wallet)"
        poolYear.text = "Pool Year: \(user.poolYear)"
//        userLevel.text = String(format: "%.2f", user.cursusUsers[1].level)
        
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
    
    // MARK: - Set Up UI
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
        ])
        
        stackView.addArrangedSubview(peerImage)
        NSLayoutConstraint.activate([
            peerImage.heightAnchor.constraint(equalToConstant: 150),
            peerImage.widthAnchor.constraint(equalToConstant: 150)
//            peerImage.widthAnchor.constraint(equalTo: peerImage.heightAnchor, multiplier: 1),
            
        ])
        stackView.addArrangedSubview(userInfo)
        
        userInfo.addArrangedSubview(userFullName)
        userInfo.addArrangedSubview(email)
        userInfo.addArrangedSubview(poolYear)
        userInfo.addArrangedSubview(wallets)
        userInfo.addArrangedSubview(userLevel)
        
//        let spacerView = UIView()
//        spacerView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addArrangedSubview(spacerView)
//        spacerView.setContentHuggingPriority(UILayoutPriority(50), for: .horizontal)
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
        ])
    }
}

// MARK: - Table View

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
        guard let user = user else {return 0}
        switch section {
        case UserDescriptionSection.skills.sectionIndex:
            return skills.count
        case UserDescriptionSection.projects.sectionIndex:
            return user.projectsUsers.count
        default:
            return 0
        }
    }
}

extension PeerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        switch indexPath.section {
        case UserDescriptionSection.skills.sectionIndex:
            let skill = skills[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillTableViewCell else { return UITableViewCell() }
            cell.configure(with: skill)
            return cell
        case UserDescriptionSection.projects.sectionIndex:
            let project = user.projectsUsers[indexPath.row].project
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
            cell.configure(with: project)
            return cell
        default:
            return UITableViewCell()
            
        }
    }
}
