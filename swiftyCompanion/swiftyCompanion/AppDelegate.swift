//
//  AppDelegate.swift
//  swiftyCompanion
//
//  Created by Zuleykha Pavlichenkova on 16.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }

}

