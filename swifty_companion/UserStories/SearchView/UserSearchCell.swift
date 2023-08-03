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
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
    func setUpUI() {
        contentView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
//        ])
    }
    
    func configure(with item: String) {
        label.text = item
    }
    
}
