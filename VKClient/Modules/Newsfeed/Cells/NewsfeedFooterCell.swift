//
//  NewsfeedFooterCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedFooterCell: UITableViewCell {

    var viewModel: NewsfeedFooterCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            likeButton.setTitle(viewModel.likesCount, for: .normal)
            commentButton.setTitle(viewModel.commentsCount, for: .normal)
            shareButton.setTitle(viewModel.sharesCount, for: .normal)
            viewsButton.setTitle(viewModel.viewsCount, for: .normal)
        }
    }

    private let stackView = UIStackView()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let viewsButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 32)
        ])

        setupButton(likeButton, imageSystemName: "heart")
        stackView.addArrangedSubview(likeButton)

        setupButton(commentButton, imageSystemName: "bubble.left")
        stackView.addArrangedSubview(commentButton)

        setupButton(shareButton, imageSystemName: "arrowshape.turn.up.right")
        stackView.addArrangedSubview(shareButton)

        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(view)

        viewsButton.setTitleColor(UIColor.vkGrayColor, for: .normal)
        viewsButton.tintColor = UIColor.vkGrayColor
        viewsButton.titleLabel?.font = .systemFont(ofSize: 14)
        viewsButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        viewsButton.imageView?.contentMode = .scaleAspectFit
        viewsButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.addArrangedSubview(viewsButton)
    }

    private func setupButton(_ button: UIButton, imageSystemName: String) {
        button.setTitleColor(UIColor.vkGrayColor, for: .normal)
        button.tintColor = UIColor.vkGrayColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: -5, bottom: 4, right: 5)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = UIColor.vkLightGrayColor
        button.setImage(UIImage(systemName: imageSystemName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 16
    }
}

