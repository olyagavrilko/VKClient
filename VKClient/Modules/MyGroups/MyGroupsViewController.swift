//
//  MyGroupsViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.07.2021.
//

import UIKit
import RealmSwift

class MyGroupsViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()
    private var groups = [Group]()

    let realm = RealmManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        setupViews()

        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        loadData()
    }

    @objc private func addTapped() {
        let searchGroupVC = GroupSearchViewController()
        searchGroupVC.delegate = self
        navigationController?.pushViewController(searchGroupVC, animated: true)
    }

    func loadData() {
        apiService.getGroups { result in
            switch result {
            case .success(let groups):
                self.groups = groups
                self.saveGroupsData(groups)
            case .failure:
                self.groups = self.realm?.getObjects(type: Group.self).toArray() ?? []
            }
            self.tableView.reloadData()
        }
    }

    private func saveGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: .modified)
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

extension MyGroupsViewController: UITableViewDelegate {
    private func leaveButtonDidTap(with indexPath: Int) {
        apiService.leaveGroup(id: groups[indexPath].id) { response in
            if response == 1 {
                self.loadData()
                self.tableView.reloadData()
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
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GroupCell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            return UITableViewCell()
        }
        cell.groupItem = groups[indexPath.row]
        return cell
    }
}

extension MyGroupsViewController: GroupSearchViewControllerDelgate {

    func groupSelected() {
        loadData()
    }
}
