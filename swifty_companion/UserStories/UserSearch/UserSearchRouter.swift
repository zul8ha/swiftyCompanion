//
//  UserSearchRouter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 14.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class UserSearchRouter: UserSearchRoutable {
    
    private let userDetailsBuilder: UserDetailsBuildable
    weak var transitionHandler: UIViewController?
    
    init(userDetailsBuilder: UserDetailsBuildable) {
        self.userDetailsBuilder = userDetailsBuilder
    }
    
    func showUserDetails(with login: String) {
        let detailsViewController = userDetailsBuilder.build(login: login)
        transitionHandler?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
