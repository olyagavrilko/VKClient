//
//  Photos.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.07.2021.
//

import Foundation
import RealmSwift

// MARK: - Welcome
struct PhotoResponse: Decodable {
    let response: InternalPhotoResponse
}

// MARK: - Response
struct InternalPhotoResponse: Decodable {
    let count: Int
    let items: [Photo]
}

// MARK: - Item
class Photo: Object, Decodable {
    var sizes = List<Size>()
    @objc dynamic var id = 0
    @objc dynamic var owner_id = 0

    var size: Size? {
        sizes.last
    }

    var url: String? {
        guard let size = size else {
            return nil
        }
        return size.url
    }

    var aspectRatio: CGFloat? {
        guard let size = size else {
            return nil
        }
        return CGFloat(size.height) / CGFloat(size.width)
    }

    override class func primaryKey() -> String? {
        "id"
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height = 0
    @objc dynamic var url: String? = nil
    @objc dynamic var type = ""
    @objc dynamic var width = 0
}
