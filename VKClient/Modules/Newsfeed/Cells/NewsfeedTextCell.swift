//
//  NewsfeedTextCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedTextCell: UITableViewCell {

    private let scrollView = UIScrollView()
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        label.numberOfLines = 0
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5)
        ])
    }
}
