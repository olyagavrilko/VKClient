//
//  FriendCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 07.07.2021.
//

import UIKit

class FriendCell: UITableViewCell {

    let photoImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    var friendItem: User? {
        didSet {
            guard let friendItem = friendItem else {
                return
            }
//            guard let city = friendItem.city?.title else {
//                return
//            }
//            guard let image = photoImageView.load(friendItem.photo100) else {
//                return
//            }
//            photoImageView.image = image
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

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupViews()
//    }

    private func setupViews() {
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 30
        photoImageView.clipsToBounds = true
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            photoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        titleLabel.backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }

//    func configure(withFriend friend: User) {
//        titleLabel = friend.firstName
//    }
}
