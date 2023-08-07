//
//  UserSearchCell.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 8/3/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

final class UserSearchCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var imagePreview: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = 45
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var layerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
    
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 4
//        stack.backgroundColor = .lightGray
//        stack.layer.cornerRadius = 5
        return stack
    }()

    // MARK: - inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setUpUI
    func setUpUI() {
        contentView.addSubview(imagePreview)
        NSLayoutConstraint.activate([
            imagePreview.widthAnchor.constraint(equalToConstant: 90),
            imagePreview.heightAnchor.constraint(equalToConstant: 90),
            
            imagePreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imagePreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            imagePreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        contentView.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: imagePreview.trailingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        infoStackView.addArrangedSubview(loginLabel)
        infoStackView.addArrangedSubview(fullNameLabel)
        infoStackView.addArrangedSubview(layerView)

        layerView.addSubview(paddingView)
        layerView.addSubview(kindLabel)
        NSLayoutConstraint.activate([
            kindLabel.topAnchor.constraint(equalTo: layerView.topAnchor, constant: 4),
            kindLabel.leadingAnchor.constraint(equalTo: layerView.leadingAnchor, constant: 8),
            kindLabel.bottomAnchor.constraint(equalTo: layerView.bottomAnchor, constant: -4),

            paddingView.topAnchor.constraint(equalTo: kindLabel.topAnchor, constant: -4),
            paddingView.leadingAnchor.constraint(equalTo: kindLabel.leadingAnchor, constant: -8),
            paddingView.trailingAnchor.constraint(equalTo: kindLabel.trailingAnchor, constant: 8),
            paddingView.bottomAnchor.constraint(equalTo: kindLabel.bottomAnchor, constant: 4),
        ])
    }
    
    // MARK: - table view cell
    override func prepareForReuse() {
        super.prepareForReuse()
        loginLabel.text = ""
        fullNameLabel.text = ""
        imagePreview.image = UIImage(systemName: "person")
    }
    
    func configure(with item: UserSearchResult) {
        loginLabel.text = item.login
        fullNameLabel.text = item.usualFullName
        kindLabel.text = item.kind
        
        if let imageLink = item.image?.link {
            loadImage(with: imageLink)
        } else {
            imagePreview.image = UIImage()
        }
    }
    
    func loadImage(with imageURLString: String) {
        guard let url = URL(string: imageURLString) else { return }
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let data = data,
                    !data.isEmpty,
                    let image = UIImage(data: data) {
                    self.imagePreview.image = image
                }
            }
        }
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
