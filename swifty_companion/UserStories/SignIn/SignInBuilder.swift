//
//  SignInBuilder.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 19.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol SignInBuildable {
    func build(listener: SignInListener) -> UIViewController
}

final class SignInBuilder: SignInBuildable {
    let authManager: IAuthManager
    
    init(authManager: IAuthManager) {
        self.authManager = authManager
    }
    
    func build(listener: SignInListener) -> UIViewController {
        let viewController = SignInViewController(
            authManager: authManager
        )
        viewController.listener = listener
        viewController.isModalInPresentation = true
        return viewController
    }
}
