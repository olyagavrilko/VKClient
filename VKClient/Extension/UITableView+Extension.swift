//
//  UITableView+Extension.swift
//  VKClient
//
//  Created by Olya Ganeva on 28.01.2022.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            return T()
        }
        return cell
    }
}
