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
class InternalPhotoResponse: Object, Decodable {
    @objc dynamic var count: Int
    let items: [Photo]
}

// MARK: - Item
class Photo: Object, Decodable {
    @objc dynamic var albumID, date, id, ownerID: Int
    @objc dynamic var hasTags: Bool
    let sizes: [Size]
    @objc dynamic var text: String
    let likes: Likes
    let reposts: Reposts
    let postID: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case sizes, text, likes, reposts
        case postID = "post_id"
    }
}

// MARK: - Likes
class Likes: Object, Codable {
    @objc dynamic var userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
class Reposts: Object, Codable {
    @objc dynamic var count: Int
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height: Int
    @objc dynamic var url: String?
    @objc dynamic var type: String
    @objc dynamic var width: Int
}
