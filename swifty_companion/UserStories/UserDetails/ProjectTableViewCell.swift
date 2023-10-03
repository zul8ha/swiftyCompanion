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
    
    private lazy var markLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .heavy)
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
    
    func configure(with item: ProjectItem) {
        projectLabel.text = item.title
        markLabel.text = String(item.finalMark)
        if item.finalMark >= 60 && item.status == .finished {
            markLabel.textColor = .systemGreen
        } else {
            markLabel.textColor = .systemRed
        }
    }
    
    func setUpUI() {
        contentView.addSubview(projectLabel)
        NSLayoutConstraint.activate([
            projectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            projectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            projectLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        contentView.addSubview(markLabel)
        NSLayoutConstraint.activate([
            markLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            markLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            markLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
