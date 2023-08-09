//
//  SkillTableViewCell.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/16/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 740), for: .horizontal)
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    private lazy var levelProgressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progress = 0.0
        progress.progressTintColor = .systemBlue
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .lightGray
        
        return progress
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        levelLabel.text = ""
    }
    
    func setUpUI() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
        ])
        
        contentView.addSubview(levelLabel)
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            levelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        contentView.addSubview(levelProgressBar)
        NSLayoutConstraint.activate([
            levelProgressBar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            levelProgressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            levelProgressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            levelProgressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    
    func configure(with item: Skill) {
        nameLabel.text = item.name
        levelLabel.text = String(format: "%.2f", item.level)
        guard let levelString = levelLabel.text else { return }
        guard let level = Float(levelString) else {return}
        levelProgressBar.progress = level / 20.0
    }
    
}

