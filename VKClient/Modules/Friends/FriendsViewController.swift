//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import UIKit

//struct User1 {
//    var name: String
//}

final class FriendsViewController: UIViewController {

//    let users = [
//        User1(name: "1"),
//        User1(name: "2"),
//        User1(name: "3"),
//        User1(name: "4")
//    ]

    private let tableView = UITableView()
    private let apiService = APIService()
    var friends = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
//        tableView.delegate = self
        tableView.dataSource = self

        apiService.getFriends { users in

            self.friends = users
            self.tableView.reloadData()
//            print(users)
        }
//        apiService.getPhotos()
//        apiService.getGroups()
//        apiService.searchGroups()
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


extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FriendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.friendItem = friends[indexPath.row]

        return cell
    }
}
