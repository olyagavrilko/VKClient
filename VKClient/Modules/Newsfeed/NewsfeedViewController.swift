//
//  NewsfeedViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

struct NewsfeedHeaderCellViewModel {

}

struct NewsfeedTextCellViewModel {

}

struct NewsfeedPhotoCellViewModel {

}

struct NewsfeedFooterCellViewModel {

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

    var sections: [NewsfeedSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let item = sections[indexPath.section].items[indexPath.row]
//
//        switch item {
//        case .header(let viewModel):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
//                return UITableViewCell()
//            }
//            cell.viewModel = viewModel
//            return cell
//        case .text(let viewModel):
//        case .photo(let viewModel):
//        case .footer(let viewModel):
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)

        return UITableViewCell()
    }
}
