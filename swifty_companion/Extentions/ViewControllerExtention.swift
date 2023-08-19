//
//  ViewControllerExtention.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 19.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
