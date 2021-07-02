//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import UIKit

final class FriendsViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        apiService.getFriends { users in
            print("getFriends")
        }
        apiService.getPhotos()
        apiService.getGroups()
        apiService.searchGroups()
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}