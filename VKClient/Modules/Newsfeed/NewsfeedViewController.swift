//
//  NewsfeedViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

struct NewsfeedHeaderCellViewModel {
    let title: String
    let photo: String
    let date: String
}

struct NewsfeedTextCellViewModel {
    let text: String
}

struct NewsfeedPhotoCellViewModel {
    let imageURL: String
}

struct NewsfeedFooterCellViewModel {
    let likesCount: String
    let commentsCount: String
    let sharesCount: String
    let viewsCount: String
}

enum NewsfeedCellViewModel {
    case header(NewsfeedHeaderCellViewModel)
    case text(NewsfeedTextCellViewModel)
    case photo(NewsfeedPhotoCellViewModel)
    case footer(NewsfeedFooterCellViewModel)
}

struct NewsfeedSection {
    let items: [NewsfeedCellViewModel]
}

final class NewsfeedViewController: UIViewController {

    private let tableView = UITableView()

    private let presenter = NewsfeedPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self

        setupViews()

        tableView.register(NewsfeedHeaderCell.self, forCellReuseIdentifier: "NewsfeedHeaderCell")
        tableView.register(NewsfeedTextCell.self, forCellReuseIdentifier: "NewsfeedTextCell")
        tableView.register(NewsfeedPhotoCell.self, forCellReuseIdentifier: "NewsfeedPhotoCell")
        tableView.register(NewsfeedFooterCell.self, forCellReuseIdentifier: "NewsfeedFooterCell")
        tableView.delegate = self
        tableView.dataSource = self

        presenter.loadData()
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

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = presenter.sections[indexPath.section].items[indexPath.row]

        switch item {
        case .header(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedHeaderCell", for: indexPath) as? NewsfeedHeaderCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        case .text(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedTextCell", for: indexPath) as? NewsfeedTextCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        case .photo(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedPhotoCell", for: indexPath) as? NewsfeedPhotoCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        case .footer(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedFooterCell", for: indexPath) as? NewsfeedFooterCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        }
    }
}

extension NewsfeedViewController: NewsfeedViewProtocol {

    func update() {
        self.tableView.reloadData()
    }
}