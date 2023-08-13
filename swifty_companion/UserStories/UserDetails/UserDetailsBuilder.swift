//
//  UserDetailsBuilder.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 13.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol UserDetailsBuildable {
    func build(login: String) -> UIViewController
}

final class UserDetailsBuilder: UserDetailsBuildable {
    
    private let userService: IUserService
    
    init(
        userService: IUserService
    ) {
        self.userService = userService
    }
    
    func build(login: String) -> UIViewController {

        let presenter = UserDetailsPresenter(
            login: login,
            userService: userService
        )
        
        let viewController = UserDetailsViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
