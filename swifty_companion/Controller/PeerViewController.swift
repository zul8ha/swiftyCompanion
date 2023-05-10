//
//  PeerViewController.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/10/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class PeerViewController: UIViewController {
    
    var login: String?
    
    private lazy var label: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO show login in the label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        print("setupui of PeerViewController")
    }
}
