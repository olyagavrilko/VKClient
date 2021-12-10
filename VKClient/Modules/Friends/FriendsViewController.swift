//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import UIKit
import RealmSwift

final class FriendsViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()
    private var friends: Results<User>?

    let realm = RealmManager.shared
    var token: NotificationToken?

    override func viewDidLoad() {

        super.viewDidLoad()
        setupViews()
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        loadFromCache()
        subscribe()
        loadData()
    }

    private func loadFromCache() {
        friends = realm?.getObjects(type: User.self)
        tableView.reloadData()
    }

    private func subscribe() {
        friends = realm?.getObjects(type: User.self)

        token = friends?.observe { [weak self] changes in

            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_,
                         let deletions,
                         let insertions,
                         let modifications):
                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }

                DispatchQueue.main.async {
                    self?.tableView.beginUpdates()
                    self?.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self?.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self?.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self?.tableView.endUpdates()
                }
            case .error(let error):
                print("\(error)")
            }
        }
    }

    private func loadData() {
        apiService.getFriends { result in
            switch result {
            case .success(let users):
                self.saveFriendsData(users)
            case .failure:
                break
            }
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
        return friends?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FriendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.friendItem = friends?[indexPath.row]

        return cell
    }
}
extension FriendsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! FriendCell

        guard let user = friends?.first(where: { $0.id == cell.userId }) else {
            return
        }

        let vc = FriendGalleryViewController()
        vc.user = user

        navigationController?.pushViewController(vc, animated: true)
    }
}
