//
//  UserSearchPresenter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 13.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol UserSearchRoutable {
    func showUserDetails(with login: String)
}

protocol UserSearchViewControllable: AnyObject {
    func reloadData()
    func showError(message: String)
}

final class UserSearchPresenter: UserSearchPresentable {
    
    weak var view: UserSearchViewControllable?
    var users: [UserSearchResult] = []
    private let router: UserSearchRoutable
    private let userService: IUserService

    init(
        router: UserSearchRoutable,
        userService: IUserService
    ) {
        self.router = router
        self.userService = userService
    }
    
    func search(with queryString: String) {
        userService.search(
            with: queryString
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleUserSearch(result: result)
            }
        }
    }
    
    func handleUserSearch(result: Result<[UserSearchResult], Error>) {
        switch result {
        case let .success(users):
            self.users = users
            view?.reloadData()
        case let .failure(error):
            view?.showError(message: error.localizedDescription)
            // TODO: Add alert
            print(#function, "🚨 \(error)")
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let login: String = users[indexPath.row].login
        router.showUserDetails(with: login)
    }
}
