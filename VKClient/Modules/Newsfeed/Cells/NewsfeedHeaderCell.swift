//
//  NewsfeedHeaderCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedHeaderCell: UITableViewCell {

    var viewModel: NewsfeedHeaderCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            photoImageView.load(viewModel.photo)
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.date
        }
    }

    private let photoImageView = CachedImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalToConstant: 40),
            photoImageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.backgroundColor = .white
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
