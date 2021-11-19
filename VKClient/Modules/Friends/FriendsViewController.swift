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
    var friends = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        apiService.getFriends { users in

            self.friends = users
            self.tableView.reloadData()
        }
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
extension FriendsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! FriendCell

        let vc = FriendGalleryViewController()
        vc.userId = cell.userId
        
        apiService.getPhotos(userId: "\(cell.userId)") { photos in

            vc.photos = photos
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}
