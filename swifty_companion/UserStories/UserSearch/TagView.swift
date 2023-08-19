//
//  TagView.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 19.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class TagView: UIView {
    
    enum Tag {
        case kind(title: String)
        case alumni
        case staff
        
        var text: String {
            switch self{
            case let .kind(title):
                return title
            case .alumni:
                return "alumni"
            case .staff:
                return "staff"
            }
        }
        
        var color: UIColor {
            switch self {
            case .kind:
                return .systemOrange
            case .alumni:
                return .systemYellow
            case .staff:
                return .systemTeal
            }
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 1
    
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tag: Tag) {
        label.text = tag.text
        backgroundColor = tag.color
    }
    
}
