//
//  UserSearchPresenter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 13.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol UserSearchListener: AnyObject {
    func didSignOut()
}

protocol UserSearchRoutable {
    func showUserDetails(with login: String)
}

protocol UserSearchViewControllable: AnyObject {
    func reloadData()
    func showError(_ message: String)
}

final class UserSearchPresenter: UserSearchPresentable {
    
    weak var view: UserSearchViewControllable?
    weak var listener: UserSearchListener?
    
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
            switch error {
            case HTTPClientError.unauthorized:
                listener?.didSignOut()
            default:
                view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let login: String = users[indexPath.row].login
        router.showUserDetails(with: login)
    }
    
    func didSignOut() {
        listener?.didSignOut()
    }
}
