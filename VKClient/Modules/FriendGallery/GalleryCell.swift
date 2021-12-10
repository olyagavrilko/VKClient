//
//  GalleryCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import UIKit

class GalleryCell: UICollectionViewCell {

    private let imageView = CachedImageView()

    var photo: Photo? {
        didSet {
            guard let photo = photo else {
                return
            }

            guard let url = photo.sizes.first?.url else {
                return
            }

            imageView.load(url)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
}
