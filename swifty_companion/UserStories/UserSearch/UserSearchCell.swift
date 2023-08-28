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
        image.layer.masksToBounds = false
        image.layer.borderWidth = 4
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = 45
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
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
    
    private lazy var tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    
    private lazy var kindTagView: TagView = {
        let tag = TagView()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.configure(with: .kind(title: ""))
        return tag
    }()
    
    private lazy var alumniTagView: TagView = {
        let tag = TagView()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.configure(with: .alumni)
        tag.isHidden = true
        return tag
    }()
    
    private lazy var staffTagView: TagView = {
        let tag = TagView()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.configure(with: .staff)
        tag.isHidden = true
        return tag
    }()
    
    private let imageService = ImageService.shared
    
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
        ])
        
        infoStackView.addArrangedSubview(loginLabel)
        infoStackView.addArrangedSubview(fullNameLabel)
        contentView.addSubview(tagsStackView)
        NSLayoutConstraint.activate([
            tagsStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8),
            tagsStackView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            tagsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        tagsStackView.addArrangedSubview(kindTagView)
        tagsStackView.addArrangedSubview(alumniTagView)
        tagsStackView.addArrangedSubview(staffTagView)
    }
    
    // MARK: - table view cell
    override func prepareForReuse() {
        super.prepareForReuse()
        loginLabel.text = ""
        fullNameLabel.text = ""
        alumniTagView.isHidden = true
        staffTagView.isHidden = true
        imagePreview.image = UIImage()
        imagePreview.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configure(with item: UserSearchResult) {
        loginLabel.text = item.login
        fullNameLabel.text = item.usualFullName
        kindTagView.configure(with: TagView.Tag.kind(title: item.kind))
        alumniTagView.isHidden = !item.alumni
        staffTagView.isHidden = !item.staff
        
        if let imageLink = item.image?.link {
            imageService.loadImage(with: imageLink) { result in
                DispatchQueue.main.async {
                    self.handleImageLoadingResult(with: result)
                }
            }
            guard item.active else { return }
            imagePreview.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            // TODO: Put default image
            imagePreview.image = UIImage()
        }
    }
    
    func handleImageLoadingResult(with result: Result<UIImage, Error>) {
        switch result {
        case .success(let image):
            self.imagePreview.image = image
        case .failure(let error):
            print("Failed to load imagePreview: \(error)")
        }
    }
}
