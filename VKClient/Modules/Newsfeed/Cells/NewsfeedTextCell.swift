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
            textView.text = viewModel.text
//            label.text = viewModel.text
        }
    }

//    private let scrollView = UIScrollView()
//    private let containerView = UIView()
//    private let label = UILabel()

    private let textView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }

//    private func setupViews() {
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
//        scrollView.contentInset.bottom = 20
//        scrollView.backgroundColor = .yellow
//        addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            scrollView.topAnchor.constraint(equalTo: topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
////            scrollView.heightAnchor.constraint(equalToConstant: 100),
//            scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//        ])
//
//        scrollView.addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
////            containerView.heightAnchor.constraint(equalToConstant: 100),
//            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//        ])
//
//        label.numberOfLines = 0
//        containerView.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
//            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
//            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
//            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
//        ])
//    }
}
