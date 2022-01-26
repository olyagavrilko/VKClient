//
//  NewsfeedTextCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedTextCell: UITableViewCell {

    var viewModel: NewsfeedTextCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            label.text = viewModel.text
        }
    }

    private let label = UILabel()
    private let button = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        label.backgroundColor = .white
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])

        button.addTarget(self, action: #selector(showMoreButtonDidTap), for: .touchUpInside)
        button.setTitle("Показать полностью...", for: .normal)
        button.setTitleColor(UIColor(red: 44/255, green: 89/255, blue: 132/255, alpha: 1), for: .normal)
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func showMoreButtonDidTap() {

    }
}
