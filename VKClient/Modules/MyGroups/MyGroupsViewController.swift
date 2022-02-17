//
//  MyGroupsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.07.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class MyGroupsViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()
    private var groups: Results<Group>?
    private var communitiesFirebase = [FirebaseCommunity]()
    private var ref = Database.database().reference(withPath: "Users")

    private let groupsAdapter = GroupsAdapter()

    private var cellConfigs: [GroupCell.Config] = []

    let realm = RealmManager.shared
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        setupViews()

        tableView.register(cellClass: GroupCell.self)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        loadFromCache()
        subscribe()
        loadData()

        ref.observe(.value) { snapshot in
            var communities: [FirebaseCommunity] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let city = FirebaseCommunity(snapshot: snapshot) {
                    communities.append(city)
                }
            }
            communities.forEach { print($0.name) }
            print(communities.count)
        }
    }

    @objc private func addTapped() {
        let searchGroupVC = GroupSearchViewController()
        searchGroupVC.delegate = self
        navigationController?.pushViewController(searchGroupVC, animated: true)
    }

    func loadData() {
//        apiService.getGroups { result in
//            switch result {
//            case .success(let groups):
//                self.saveGroupsData(groups)
//            case .failure:
//                break
//            }
//        }

//        apiService.getGroupsForAdapter(delegate: self)

        groupsAdapter.getGroups { [weak self] groups in
            self?.saveGroupsData(groups)
        }
    }

    func subscribe() {
        self.groups = self.realm?.getObjects(type: Group.self)

        token = groups?.observe { changes in

            switch changes {
            case .initial:
                self.updateView()

            case .update(_,
                         let deletions,
                         let insertions,
                         let modifications):
//                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
//                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
//                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }

//                DispatchQueue.main.async {
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
//                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
//                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
//                    self.tableView.endUpdates()
//                }
                self.updateView()

            case .error(let error):
                print("\(error)")
            }
        }
    }

    private func loadFromCache() {
        self.groups = self.realm?.getObjects(type: Group.self)
        self.updateView()
    }

    private func saveGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: .modified)
            let cachedGroups = realm.objects(Group.self).toArray()
            let deletedGroups = cachedGroups.filter { cachedGroup in
                !groups.contains { $0.id == cachedGroup.id }
            }
            deletedGroups.forEach {
                realm.delete($0)
            }
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

    func makeConfigs(using groups: Results<Group>) -> [GroupCell.Config] {
        groups.compactMap { group in
            guard let activity = group.activity else {
                return nil
            }
            return GroupCell.Config(imageURL: group.photo100, title: group.name, subtitle: activity)
        }
    }

    func updateView() {
        guard let groups = groups else {
            return
        }
        cellConfigs = makeConfigs(using: groups)
        tableView.reloadData()
    }
}

extension MyGroupsViewController: UITableViewDelegate {
    private func leaveButtonDidTap(with indexPath: Int) {
        guard let id = groups?[indexPath].id else {
            return
        }

        apiService.leaveGroup(id: id) { response in
            if response == 1 {
                self.loadData()
                self.updateView()
            }
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: "Покинуть сообщество") { [weak self] (action, view, completionHandler) in
            self?.leaveButtonDidTap(with: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension MyGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupCell.self, for: indexPath)
        cell.update(with: cellConfigs[indexPath.row])
        return cell
    }
}

extension MyGroupsViewController: GroupSearchViewControllerDelgate {

    func groupSelected(id: Int, name: String) {
        let firebaseUser = FirebaseUser(id: Int(Session.shared.userId) ?? 0)
        firebaseUser.communities.append(FirebaseCommunity(name: name, id: id))

        let userRef = self.ref.child(Session.shared.userId)
        userRef.setValue(firebaseUser.toAnyObject())
        loadData()
    }
}

extension MyGroupsViewController: ApiGroupsDelegate {

    func returnGroups(_ groups: [Group]) {
        saveGroupsData(groups)
    }
}
