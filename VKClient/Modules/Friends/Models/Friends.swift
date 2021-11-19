//
//  Friends.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import Foundation

// MARK: - Welcome
struct UsersResponse: Decodable {
    let response: InternalUsersResponse
}

// MARK: - Response
struct InternalUsersResponse: Decodable {
    let count: Int
    let items: [User]
}

// MARK: - Item
class User: Decodable {
    let firstName: String
    let id: Int
    let lastName: String
    let photo100: String
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
struct City: Codable {
    let id: Int
    let title: String
}
