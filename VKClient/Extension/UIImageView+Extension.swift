//
//  UIImageView+Extension.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.07.2021.
//

import UIKit

final class CachedImageView: UIImageView {

    private var imageURL: URL?

    private let photoFileService = PhotoFileService.shared

    static var dict: [URL: UIImage] = [:]

    func load(_ urlString: String) {

        guard let url = URL(string: urlString) else {
            return
        }

        imageURL = url

        if let image = Self.dict[url] {
            self.image = image
        } else if let image = photoFileService.image(by: url) {
            Self.dict[url] = image
            self.image = image
        } else {
            loadImage(by: url)
        }
    }

    private func loadImage(by url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        Self.dict[url] = image
                        self?.photoFileService.save(image: image, with: url)
                        if self?.imageURL == url {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
