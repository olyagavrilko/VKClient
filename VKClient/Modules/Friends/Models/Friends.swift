//
//  Friends.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import Foundation

// MARK: - Welcome
struct UsersResponse: Codable {
    let response: InternalUsersResponse
}

// MARK: - Response
struct InternalUsersResponse: Codable {
    let count: Int
    let items: [User]
}

// MARK: - Item
class User: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let photo100: String
    let city: City?
    let trackCode: String
    let lists: [Int]?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photo100 = "photo_100"
        case city
        case trackCode = "track_code"
        case lists
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let title: String
}

//enum Title: String, Codable {
//    case atlanta = "Atlanta"
//    case losAngeles = "Los Angeles"
//    case владивосток = "Владивосток"
//    case москва = "Москва"
//    case санктПетербург = "Санкт-Петербург"
//    case уссурийск = "Уссурийск"
//}

