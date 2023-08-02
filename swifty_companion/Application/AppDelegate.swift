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
    
    private let keyValyeStorage: IKeyValueStorage = KeyValueStorage()
    private lazy var authManager: IAuthManager = AuthManager(keyValueStorage: keyValyeStorage)
    private lazy var appRouter: IAppRouter = AppRouter(with: authManager)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        
//        print("!!! 🚀 \(authManager.authState)")
        
        appRouter.startApp(in: window)
        return true
    }
}


