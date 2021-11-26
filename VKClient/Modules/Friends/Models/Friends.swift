//
//  Friends.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import Foundation
import RealmSwift

// MARK: - Welcome
struct UsersResponse: Decodable {
    let response: InternalUsersResponse
}

// MARK: - Response
class InternalUsersResponse: Object, Decodable {
    @objc dynamic var count: Int
    let items: [User]
}

// MARK: - Item
class User: Object, Decodable {
    @objc dynamic var firstName: String
    @objc dynamic var id: Int
    @objc dynamic var lastName: String
    @objc dynamic var photo100: String
    let city: City?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photo100 = "photo_100"
        case city
    }
}

// MARK: - City
class City: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var title: String
}
