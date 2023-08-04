//
//  UserSearchCell.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 8/3/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class UserSearchCell: UITableViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
    func configure(with item: String) {
        label.text = item
    }
    
}
