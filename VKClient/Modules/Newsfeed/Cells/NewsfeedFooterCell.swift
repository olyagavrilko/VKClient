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
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let shareButton = UIButton()
    private let viewsButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.heightAnchor.constraint(equalToConstant: 20)
        ])

        likeButton.setImage(UIImage(named: "heart"), for: .normal)
        stackView.addArrangedSubview(likeButton)

        commentButton.setImage(UIImage(named: "bubble.left"), for: .normal)
        stackView.addArrangedSubview(commentButton)

        shareButton.setImage(UIImage(named: "arrowshape.turn.up.right"), for: .normal)
        stackView.addArrangedSubview(shareButton)

        viewsButton.setImage(UIImage(named: "eye.fill"), for: .normal)
        addSubview(viewsButton)
        viewsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            viewsButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

