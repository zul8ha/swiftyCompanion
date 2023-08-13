//
//  StartViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//
/// For the filtering https://www.kodeco.com/4363809-uisearchcontroller-tutorial-getting-started
/// https://api.intra.42.fr/v2/users?range[login]=hmer,hmerz

import UIKit

protocol UserSearchListener: AnyObject {
    func didSignOut()
}

final class UserSearchViewController: UIViewController {
    // MARK: - searchController
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
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
    
    private var accessToken: AccessToken
    private let userService: IUserService
    
    weak var listener: UserSearchListener?
    
    var users: [UserSearchResult] = []
    
    init(accessToken: AccessToken, userService: IUserService) {
        self.accessToken = accessToken
        self.userService = userService
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
    
    
    
    func handleUserSearch(result: Result<[UserSearchResult], Error>) {
        switch result {
        case let .success(users):
            self.users = users
            tableView.reloadData()
        case let .failure(error):
            // TODO: Add alert
            print(#function, "🚨 \(error)")
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        showAuthPage()
    //    }
    
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
        //        print(#function, "8888")
    }
    
    func showUserDetails(with login: String, token: AccessToken) {
        let httpClient = HTTPClient()
        //        let navigationController = UINavigationController()
        let peerViewController = UserDetailsViewController(
            accessToken: accessToken,
            httpClient: httpClient,
            login: login,
            userService: UserService(
                accessToken: token,
                httpClient: httpClient
            )
        )
        navigationController?.pushViewController(peerViewController, animated: true)
    }
    
    /// Pushes to the PeerViewController for the user from selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let login: String = users[indexPath.row].login
        showUserDetails(with: login, token: accessToken)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//extension UserSearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        //        filterContentForsearchText(searchBar.text!)
//    }
//}

extension UserSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell", for: indexPath) as? UserSearchCell else { return UITableViewCell() }
        cell.configure(with: users[indexPath.row])
        
        return cell
    }
}

extension UserSearchViewController: UITableViewDelegate {

}


extension UserSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            users = []
            tableView.reloadData()
            return
        }
        userService.search(
            with: searchText,
            accessToken: accessToken
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleUserSearch(result: result)
            }
        }
    }
}
