//
//  AppRouter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 27.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol IAppRouter {
    func startApp(in window: UIWindow)
}

final class AppRouter: IAppRouter {
    
    weak var window: UIWindow?
    var navigationController: UINavigationController?
    let authManager: IAuthManager
    // TODO: add SignInBuilder, add UserSearchBuilder as dependencies
    
    init(
        with authManager: IAuthManager
    ) {
        self.authManager = authManager
    }
    
    func startApp(in window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        switch authManager.authState {
        case let .authorised(accessToken):
            showUserSearch(with: accessToken)
        case .unauthorised:
            showShigIn()
        }
    }
    
    func showShigIn() {
        let viewController = SignInViewController()
        viewController.listener = self
        navigationController?.present(viewController, animated: true)
    }
    
    func showUserSearch(with accessToken: AccessToken) {
        let searchController = UserSearchViewController(accessToken: accessToken)
        navigationController?.viewControllers = [searchController]
        print(accessToken)
    }
}

extension AppRouter: SignInListener {
    func didSignIn(with accessToken: AccessToken) {
        showUserSearch(with: accessToken)
        if navigationController?.presentedViewController is SignInViewController {
            navigationController?.dismiss(animated: true)
        }
    }
}

extension AppRouter: UserSearchListener {
    func didSignOut() {
        print("\(type(of: self)) = \(#function)")
    }
}
