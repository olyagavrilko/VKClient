//
//  GroupSearchViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 17.11.2021.
//

import UIKit
import FirebaseDatabase

protocol GroupSearchViewControllerDelgate: AnyObject {
    func groupSelected(id: Int, name: String)
}

class GroupSearchViewController: UIViewController {

    private let tableView = UITableView()
    private let apiService = APIService()
    private var groups = [Group]()

    weak var delegate: GroupSearchViewControllerDelgate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupSearchBar()

        tableView.register(cellClass: GroupCell.self)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupSearchBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.placeholder = "Поиск"
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

extension GroupSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        apiService.searchGroups(text: searchText) { groups in
            self.groups = groups
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.groups = []
        self.tableView.reloadData()
    }
}

extension GroupSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "", message: "Вступить в сообщество?", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let groupID = self?.groups[indexPath.row].id,
                  let groupName = self?.groups[indexPath.row].name else {
                return
            }
            self?.apiService.joinGroup(id: groupID) { response in
                self?.delegate?.groupSelected(id: groupID, name: groupName)
            }
        })

        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension GroupSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupCell.self, for: indexPath)
        cell.groupItem = groups[indexPath.row]
        return cell
    }
}
