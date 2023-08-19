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

/// Routes the flow
final class AppRouter: IAppRouter {
    
    weak var window: UIWindow?
    private var navigationController: UINavigationController?
    private let authManager: IAuthManager
    private let httpClient = HTTPClient()
    private let searchBuilder = UserSearchBuilder()
    private let signInBuilder: SignInBuildable

    init(
        with authManager: IAuthManager
    ) {
        self.authManager = authManager
        signInBuilder = SignInBuilder(authManager: authManager)
    }
    
    /// Creates an instance of the NavigationController, makes it a rootVC of the window and makes it key&visible
    /// In case we have a valid access token, shows the SeatchVC, otherwise - signInVC
    /// - Parameter window: came from the AppDelegate
    func startApp(in window: UIWindow) {
        self.window = window
        
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        switch authManager.authState {
        case let .authorised(accessToken):
            let userService = UserService(
                accessToken: accessToken,
                httpClient: httpClient
            )
            showUserSearch(
                userService: userService
            )
        case .unauthorised:
            showShigIn()
        }
    }
    
    func showShigIn() {
        let viewController = signInBuilder.build(listener: self)
        navigationController?.present(viewController, animated: true)
    }
    
    func showUserSearch(userService: UserService) {
        let searchController = searchBuilder.build(
            listener: self,
            userService: userService
        )
        navigationController?.viewControllers = [searchController]
    }
}

extension AppRouter: SignInListener {
    func didSignIn(with accessToken: AccessToken) {
        let userService = UserService(
            accessToken: accessToken,
            httpClient: httpClient
        )
        showUserSearch(userService: userService)
        if navigationController?.presentedViewController is SignInViewController {
            navigationController?.dismiss(animated: true)
        }
    }
}

extension AppRouter: UserSearchListener {
    func didSignOut() {
        authManager.logOut()
        showShigIn()
        navigationController?.viewControllers = []
    }
}
