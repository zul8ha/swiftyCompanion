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
    
    private let accessToken: AccessToken
    private let httpClient: IHTTPClient
    private let userService: IUserService
    
    init(
        accessToken: AccessToken,
        httpClient: IHTTPClient,
        userService: IUserService
    ) {
        self.accessToken = accessToken
        self.httpClient = httpClient
        self.userService = userService
    }
    
    func build(login: String) -> UIViewController {

        let detailsViewController = UserDetailsViewController(
            accessToken: accessToken,
            httpClient: httpClient,
            login: login,
            userService: UserService(
                accessToken: accessToken,
                httpClient: httpClient
            )
        )
        return detailsViewController
    }
}
