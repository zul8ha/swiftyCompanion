//
//  AppRouter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 27.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class AppRouter {
    
    weak var window: UIWindow?
    var navigationController: UINavigationController?
    
    func startApp(in window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showShigIn()
    }
    
    func showShigIn() {
        let viewController = SignInViewController()
        viewController.listener = self
        navigationController?.present(viewController, animated: true)
    }
    
    func showUserSearch(with token: Token) {
        let searchController = UserSearchViewController(decodedToken: token)
        navigationController?.viewControllers = [searchController]
        
    }
}

extension AppRouter: SignInListener {
    func didSignIn(with token: Token) {
        showUserSearch(with: token)
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
