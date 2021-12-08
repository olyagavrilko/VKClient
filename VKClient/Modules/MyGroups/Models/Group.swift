//
//  Group.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.07.2021.
//

import Foundation

struct GroupsResponse: Decodable {
    let response: InternalGroupsResponse
}

struct InternalGroupsResponse: Decodable {
    let count: Int
    let items: [Group]
}

struct Group: Decodable {
    let id: Int
    let name: String
    let photo100: String
    var activity: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo100 = "photo_100"
        case activity
    }
}

struct JoinResponse: Decodable {
    let response: Int
}

struct LeaveResponse: Decodable {
    let response: Int
}
