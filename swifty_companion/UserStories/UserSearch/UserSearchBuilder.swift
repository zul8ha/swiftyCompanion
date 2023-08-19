//
//  UserSearchBuilder.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 13.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol UserSearchBuildable {
    func build(listener: UserSearchListener, userService: IUserService) -> UIViewController
}

final class UserSearchBuilder: UserSearchBuildable {
    
    func build(
        listener: UserSearchListener,
        userService: IUserService
    ) -> UIViewController {
        
        let userDetailsBuilder = UserDetailsBuilder(userService: userService)
        let router = UserSearchRouter(userDetailsBuilder: userDetailsBuilder)
        let presenter = UserSearchPresenter(router: router, userService: userService)
        
        let searchController = UserSearchViewController(presenter: presenter, userService: userService)
        presenter.view = searchController
        presenter.listener = listener
        router.transitionHandler = searchController
        return searchController
    }
}
