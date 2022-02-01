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
    var isOpen: Bool
    let openCloseAction: (IndexPath) -> Void
}

struct NewsfeedPhotoCellViewModel {
    let imageURL: String
    let aspectRatio: CGFloat
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
    var items: [NewsfeedCellViewModel]
}

final class NewsfeedViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let presenter = NewsfeedPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self

        setupViews()
        setupRefreshControl()

        tableView.register(cellClass: NewsfeedHeaderCell.self)
        tableView.register(cellClass: NewsfeedTextCell.self)
        tableView.register(cellClass: NewsfeedPhotoCell.self)
        tableView.register(cellClass: NewsfeedFooterCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self

        presenter.loadData()
    }

    private func setupViews() {
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()

        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }

    @objc private func refreshNews() {
        presenter.refreshNews()
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
            let cell = tableView.dequeueReusableCell(NewsfeedHeaderCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .text(let viewModel):
            let cell = tableView.dequeueReusableCell(NewsfeedTextCell.self, for: indexPath)
            cell.viewModel = viewModel
            cell.indexPath = indexPath
            return cell
        case .photo(let viewModel):
            let cell = tableView.dequeueReusableCell(NewsfeedPhotoCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .footer(let viewModel):
            let cell = tableView.dequeueReusableCell(NewsfeedFooterCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = presenter.sections[indexPath.section].items[indexPath.row]
        switch item {
        case .photo(let viewModel):
            let width = view.frame.width
            let height = width * viewModel.aspectRatio
            return height
        case .text(let viewModel):
            return NewsfeedTextCell.height(fitting: view.frame.width, viewModel: viewModel)
        case .header, .footer:
            return 40
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = presenter.sections[indexPath.section].items[indexPath.row]
        switch item {
        case .photo(let viewModel):
            let width = view.frame.width
            let height = width * viewModel.aspectRatio
            return height
        case .text(let viewModel):
            return NewsfeedTextCell.height(fitting: view.frame.width, viewModel: viewModel)
        case .header, .footer:
            return UITableView.automaticDimension
        }
    }
}

extension NewsfeedViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({$0.section}).max() else {
            return
        }

        if maxSection > presenter.sections.count - 3 {
            presenter.loadMoreNews()
        }
    }
}

extension NewsfeedViewController: NewsfeedViewProtocol {

    func update() {
        self.tableView.reloadData()
    }

    func endRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }

    func insertSections(_ indexSet: IndexSet) {
        tableView.insertSections(indexSet, with: .automatic)
    }

    func reload(_ indexPaths: [IndexPath]) {
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
}
