//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import UIKit
import RealmSwift
import Alamofire
import PromiseKit

final class FriendsViewController: UIViewController {

    private let myQueue = OperationQueue()

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

        fetchFriends()
            .then(parse(_:))
            .done(on: DispatchQueue.main) { friends in
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    realm.add(friends, update: .modified)
                    try realm.commitWrite()
                } catch {
                    print("Error")
                }
            }.catch { error in
                print(error)
            }

        loadFromCache()
        subscribe()
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

    private func fetchFriends() -> Promise<Data> {
        let url = apiService.baseURL + "/friends.get"

        let parameters: Parameters = [
            "user_id": apiService.clientID,
            "order": "name",
            "count": 50,
            "fields": "city, photo_100",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        return Promise { resolver in
            AF.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in

                guard let data = response.data else {
                    resolver.reject(NetworkError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }
        }
    }

    private func parse(_ data: Data) -> Promise<[User]> {
        return Promise { resolver in
            do {
                let response = try JSONDecoder().decode(UsersResponse.self, from: data).response
                resolver.fulfill(response.items)
            } catch {
                resolver.reject(NetworkError.failedToDecode)
            }
        }
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
