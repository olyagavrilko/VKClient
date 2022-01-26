//
//  FriendCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 07.07.2021.
//

import UIKit

class FriendCell: UITableViewCell {

    var userId = Int()
    let photoImageView = CachedImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    var friendItem: User? {
        didSet {
            guard let friendItem = friendItem else {
                return
            }

            userId = friendItem.id
            photoImageView.image = UIImage()
            photoImageView.load(friendItem.photo100)
            titleLabel.text = "\(friendItem.firstName) \(friendItem.lastName)"
            subtitleLabel.text = friendItem.city?.title
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 25
        photoImageView.clipsToBounds = true
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalToConstant: 50),
            photoImageView.heightAnchor.constraint(equalToConstant: 50)
        ])

        titleLabel.font = .systemFont(ofSize: 16)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
