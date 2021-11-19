//
//  Photos.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.07.2021.
//

import Foundation

import Foundation

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
class Photo: Decodable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let sizes: [Size]
    let text: String
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
struct Likes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count: Int
}

// MARK: - Size
struct Size: Codable {
    let height: Int
    let url: String?
    let type: String
    let width: Int
}
