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

    enum Attachment: Decodable {
        case photo(Photo)

        enum CodingKeys: String, CodingKey {
            case type
            case photo
        }

        enum AttachmentType: String {
            case photo
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeString = try container.decode(String.self, forKey: .type)

            guard let type = AttachmentType(rawValue: typeString) else {
                throw NetworkError.default
            }

            switch type {
            case .photo:
                let photo = try container.decode(Photo.self, forKey: .photo)
                self = .photo(photo)
            }
        }
    }

    let source_id: Int
    let date: Int
    let text: String
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let attachments: [Attachment]
}

struct Profile: Decodable {
    let id: Int
    let photo100: String

    enum CodingKeys: String, CodingKey {
        case id
        case photo100 = "photo_100"
    }
}
