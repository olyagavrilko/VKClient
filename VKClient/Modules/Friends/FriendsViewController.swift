//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import UIKit
import RealmSwift

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

final class FriendsViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()
    var friends = [User]()

    let realm = RealmManager.shared

    override func viewDidLoad() {

//        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

        super.viewDidLoad()
        setupViews()
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        apiService.getFriends { result in
            switch result {
            case .success(let users):
                self.friends = users
                self.saveFriendsData(users)
            case .failure:
                self.friends = self.realm?.getObjects(type: User.self).toArray() ?? []
            }
            self.tableView.reloadData()
        }
    }

    private func saveFriendsData(_ friends: [User]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.add(friends, update: .modified)
            try realm.commitWrite()
        } catch {
            print("Error")
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

        guard let user = friends.first(where: { $0.id == cell.userId }) else {
            return
        }

        let vc = FriendGalleryViewController()
        vc.user = user
        
//        apiService.getPhotos(userId: "\(cell.userId)") { photos in
//
//            vc.photos = photos
//        }

        navigationController?.pushViewController(vc, animated: true)
    }
}
