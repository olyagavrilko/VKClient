//
//  NewsfeedResponse.swift
//  VKClient
//
//  Created by Olya Ganeva on 24.12.2021.
//

import Foundation

struct NewsfeedResponse: Decodable {
    let response: InternalNewsfeedResponse
}

struct InternalNewsfeedResponse: Decodable {
    let items: [NewsItem]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

struct NewsItem: Decodable {

    struct Comments: Decodable {
        let count: Int
    }

    struct Likes: Decodable {
        let count: Int
    }

    struct Reposts: Decodable {
        let count: Int
    }

    struct Views: Decodable {
        let count: Int
    }

    struct Attachment: Decodable {
        let photo: Photo?
    }

    let sourceId: Int
    let date: Int
    let text: String
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let attachments: [Attachment]?

    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date
        case text
        case comments
        case likes
        case reposts
        case views
        case attachments
    }
}

struct Profile: Decodable {
    let id: Int
    let photo100: String
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case id
        case photo100 = "photo_100"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
