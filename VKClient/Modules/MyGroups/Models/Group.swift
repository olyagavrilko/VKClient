//
//  Group.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.07.2021.
//

import Foundation
import RealmSwift

struct GroupsResponse: Decodable {
    let response: InternalGroupsResponse
}

struct InternalGroupsResponse: Decodable {
    let count: Int
    let items: [Group]
}

class Group: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var activity: String? = nil

    override class func primaryKey() -> String? {
        "id"
    }

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
