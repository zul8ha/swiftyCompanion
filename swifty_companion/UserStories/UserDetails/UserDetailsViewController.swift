//
//  UserDetailsViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

private extension String {
    static let skillCell = "skillCell"
    static let projectCell = "projectCell"
}

protocol UserDetailsPresentable {
    var userDetailsSection: [UserDetailsSection] { get }
    func onViewDidLoad()
}

final class UserDetailsViewController: UIViewController {
    
    private let presenter: UserDetailsPresentable
    
    // MARK: - init
    init(
        presenter: UserDetailsPresentable
    ) {
        self.presenter = presenter
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
    
    private lazy var imagePaddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var peerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.tintColor = .darkGray
        image.setContentHuggingPriority(UILayoutPriority(900), for: .horizontal)
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.gray.cgColor
        
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
        return label
    }()
    
    private lazy var level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var email: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.setContentCompressionResistancePriority(UILayoutPriority(720), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(220), for: .horizontal)
        label.numberOfLines = 0
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
    
    private lazy var userLevelProgressBar: UIProgressView = {
        let levelProgress = UIProgressView(progressViewStyle: .bar)
        levelProgress.translatesAutoresizingMaskIntoConstraints = false
        levelProgress.progress = 0.0
        levelProgress.progressTintColor = .systemOrange
        levelProgress.trackTintColor = .lightGray
        levelProgress.layer.cornerRadius = 5
        levelProgress.clipsToBounds = true
        
        return levelProgress
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = UITableView.automaticDimension
        
        table.dataSource = self
        table.register(SkillTableViewCell.self, forCellReuseIdentifier: .skillCell)
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: .projectCell)
        
        return table
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter.onViewDidLoad()
    }
    
    func showUser(_ user: UserDetails) {
        userFullName.text = user.displayName
        email.text = user.email
        wallets.text = "Wallet: ₳ \(user.wallet)"
        poolYear.text = "Pool Year: \(user.poolYear)"
        if user.cursusUsers.count == 1 {
            userLevel.text = String(format: "%.2f", user.cursusUsers[0].level)
        } else {
            userLevel.text = String(format: "%.2f", user.cursusUsers[1].level)
            userLevelProgressBar.progress = Float(user.cursusUsers[1].level) / 21
        }
        
        if let imageLink = user.image?.link {
            loadImage(with: imageLink)
        }
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // TODO: Separate this to the ImageService
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
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        
        stackView.addArrangedSubview(imagePaddingView)
        imagePaddingView.addSubview(peerImage)
        NSLayoutConstraint.activate([
            peerImage.heightAnchor.constraint(equalToConstant: 120),
            peerImage.widthAnchor.constraint(equalToConstant: 120),
            peerImage.topAnchor.constraint(equalTo: imagePaddingView.topAnchor),
            peerImage.leadingAnchor.constraint(equalTo: imagePaddingView.leadingAnchor),
            peerImage.trailingAnchor.constraint(equalTo: imagePaddingView.trailingAnchor, constant: 24),
            peerImage.bottomAnchor.constraint(equalTo: imagePaddingView.bottomAnchor),
            
        ])
        stackView.addArrangedSubview(userInfo)
        
        userInfo.addArrangedSubview(userFullName)
        userInfo.addArrangedSubview(email)
        userInfo.addArrangedSubview(poolYear)
        userInfo.addArrangedSubview(wallets)
        userInfo.addArrangedSubview(userLevel)
        
        view.addSubview(userLevelProgressBar)
        userLevelProgressBar.addSubview(userLevel)
        NSLayoutConstraint.activate([
            userLevelProgressBar.heightAnchor.constraint(equalToConstant: 24),
            userLevelProgressBar.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            userLevelProgressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            userLevelProgressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            userLevel.centerXAnchor.constraint(equalTo: userLevelProgressBar.centerXAnchor),
            userLevel.centerYAnchor.constraint(equalTo: userLevelProgressBar.centerYAnchor),
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: userLevel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
        ])
    }
}

// MARK: - Table View

extension UserDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.userDetailsSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.userDetailsSection[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.userDetailsSection[section].itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSection = presenter.userDetailsSection[indexPath.section]
        switch currentSection {
        case .cursusSkillsSection(let cursusSkillsSection):
            let currenSkillItem = cursusSkillsSection.skillItems[indexPath.item]
            guard let skillCell = tableView.dequeueReusableCell(withIdentifier: .skillCell, for: indexPath) as? SkillTableViewCell else { return UITableViewCell() }
            
            skillCell.configure(with: currenSkillItem)
            return skillCell
        case .projectsSection(let projectItems):
            let currentProjectItem = projectItems[indexPath.row]
            guard let projectItemsCell = tableView.dequeueReusableCell(withIdentifier: .projectCell, for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
            
            projectItemsCell.configure(with: currentProjectItem)
            return projectItemsCell
        }
    }
}

extension UserDetailsViewController: UserDetailsViewControllable {
    func set(title: String) {
        self.title = title
    }
}
