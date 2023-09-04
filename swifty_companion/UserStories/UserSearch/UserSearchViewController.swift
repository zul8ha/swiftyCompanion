//
//  UserSearchViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//
/// For the filtering https://www.kodeco.com/4363809-uisearchcontroller-tutorial-getting-started
/// https://api.intra.42.fr/v2/users?range[login]=hmer,hmerz

import UIKit

protocol UserSearchPresentable: AnyObject {
    var users: [UserSearchResult] { get }
    
    func didSelectItem(at indexPath: IndexPath)
    func search(with queryString: String)
    func didSignOut()
}


final class UserSearchViewController: UIViewController {
    
    // MARK: - searchController
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search by peer login"
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UserSearchCell.self, forCellReuseIdentifier: "userSearchCell")
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    private let presenter: UserSearchPresentable
    private let userDetailsBuilder: UserDetailsBuildable
    
    
    init(
        presenter: UserSearchPresentable,
        userService: IUserService
    ) {
        self.presenter = presenter
        self.userDetailsBuilder = UserDetailsBuilder(
            userService: userService
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search User"
        setUpUI()
    }

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
        presenter.didSignOut()
    }
    
    func showUserDetails(with login: String) {
        
        let detailsViewController = userDetailsBuilder.build(
            login: login
        )
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension UserSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell", for: indexPath) as? UserSearchCell else { return UITableViewCell() }
        cell.configure(with: presenter.users[indexPath.row])
        
        return cell
    }
}

extension UserSearchViewController: UITableViewDelegate {
    /// Pushes to the UserDetailsViewController for the user from selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let queryString = searchBar.text else {
            return
        }
        presenter.search(with: queryString)
    }
}

extension UserSearchViewController: UserSearchViewControllable {
    func reloadData() {
        tableView.reloadData()
    }
}

