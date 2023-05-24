//
//  AppDelegate.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
//        let viewController = StartViewController()

        let viewController = SignInViewController()
        let navigationController = UINavigationController()

        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController

//        window.rootViewController = viewController
        viewController.view.backgroundColor = .systemBackground

        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    


}

