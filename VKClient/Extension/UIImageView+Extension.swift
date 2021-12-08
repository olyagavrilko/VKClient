//
//  UIImageView+Extension.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.07.2021.
//

import UIKit

//extension UIImageView {
//
//    static var dict: [String: UIImage] = [:]
//
//    func load(_ urlString: String) {
//        if let image = UIImageView.dict[urlString] {
//            self.image = image
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        UIImageView.dict[urlString] = image
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

final class CachedImageView: UIImageView {

    private var imageURL: URL?

    static var dict: [URL: UIImage] = [:]

    func load(_ urlString: String) {

        guard let url = URL(string: urlString) else {
            return
        }

        imageURL = url

        if let image = Self.dict[url] {
            self.image = image
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        Self.dict[url] = image
                        if self?.imageURL == url {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
