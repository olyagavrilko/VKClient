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

    override class func primaryKey() -> String? {
        "id"
    }

//    override class func ignoredProperties() -> [String] {
//        ["sizes"]
//    }

//    @objc dynamic var owner: User?

//    let user = LinkingObject(fromType: User.self, property: "photos")
//    let user = LinkingObjects(
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height = 0
    @objc dynamic var url: String? = nil
    @objc dynamic var type = ""
    @objc dynamic var width = 0
}
