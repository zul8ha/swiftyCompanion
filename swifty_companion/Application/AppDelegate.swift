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
        configureStorageForUITesting()
        
        let window = UIWindow()
        self.window = window
        window.backgroundColor = .systemGroupedBackground
        
        appRouter.startApp(in: window)
        return true
    }

    private func configureStorageForUITesting() {
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.contains("-ui-testing") else { return }

        keyValyeStorage.removeAllValues()

        if arguments.contains("-ui-testing-authenticated") {
            keyValyeStorage.set("ui-test-access-token", for: "accessToken")
        }
    }
}


