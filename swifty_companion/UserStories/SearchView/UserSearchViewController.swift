//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//
/// For the filtering https://www.kodeco.com/4363809-uisearchcontroller-tutorial-getting-started

import UIKit

protocol UserSearchListener: AnyObject {
    func didSignOut()
}

final class UserSearchViewController: UIViewController {
    
    var accessToken: AccessToken?
    weak var listener: UserSearchListener?
    
    // MARK:- Dummy users array and filtering by tutorial
    var users: [String] = ["hmeriann","gkarina","zkerriga","mshmelly","mcamps","cpopa","dmorfin","jlensing","cstaats","dasanero","mhogg"]
    var filteredUsers: [String] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForsearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: String) -> Bool in
            return user.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    init(accessToken: AccessToken) {
        super.init(nibName: nil, bundle: nil)
        self.accessToken = accessToken
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - searchController
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserSearchCell.self, forCellReuseIdentifier: "userSearchCell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - searchField and Button
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
//        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
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
        
        navigationItem.searchController = searchController

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
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
    
//    @objc func onButtonTapped() {
//
//        guard let login = searchField.text,
//              !login.isEmpty,
//              let token = accessToken
//        else { return }
//        showUserDetails(with: login.lowercased(), token: token)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: String
        guard let accessToken = accessToken else { return }
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        showUserDetails(with: user, token: accessToken)
    }
}

extension UserSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForsearchText(searchBar.text!)
    }
}

extension UserSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell", for: indexPath)
        let user: String
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user
        return cell
    }
}

extension UserSearchViewController: UITableViewDelegate {
//    func onButtonTapped() {
//
//        guard let login = searchField.text,
//              !login.isEmpty,
//              let token = accessToken
//        else { return }
//        showUserDetails(with: login.lowercased(), token: token)
//    }
//
}
