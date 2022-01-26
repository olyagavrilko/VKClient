//
//  NewsfeedPhotoCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedPhotoCell: UITableViewCell {

    var viewModel: NewsfeedPhotoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            photoImageView.load(viewModel.imageURL)
        }
    }

    private let photoImageView = CachedImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}
