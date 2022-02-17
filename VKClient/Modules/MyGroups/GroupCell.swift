//
//  GroupCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.07.2021.
//

import UIKit

class GroupCell: UITableViewCell {

    struct Config {
        let imageURL: String
        let title: String
        let subtitle: String
    }

    let photoImageView = CachedImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    var groupItem: Group? {
        didSet {
            guard let groupItem = groupItem else {
                return
            }

            photoImageView.image = UIImage()
            photoImageView.load(groupItem.photo100)
            titleLabel.text = groupItem.name
            subtitleLabel.text = groupItem.activity
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
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalToConstant: 50),
            photoImageView.heightAnchor.constraint(equalToConstant: 50)
        ])

        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func update(with config: Config) {
        
        photoImageView.image = UIImage()
        photoImageView.load(config.imageURL)
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
    }
}
