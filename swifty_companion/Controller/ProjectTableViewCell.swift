//
//  File.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/16/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    private lazy var projectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
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
        projectLabel.text = ""
    }
    
    func configure(with item: Project) {
        projectLabel.text = item.name
    }
    
    func setUpUI() {
        contentView.addSubview(projectLabel)
        NSLayoutConstraint.activate([
            projectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            projectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            projectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            projectLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
