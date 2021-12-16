//
//  FirebaseModel.swift
//  VKClient
//
//  Created by Olya Ganeva on 14.12.2021.
//

import Foundation
import Firebase

class FirebaseUser {

    let id: Int
    var communities: [FirebaseCommunity] = []
    let ref: DatabaseReference?
    var toFireBase: [String: Any] {
        return communities.map { $0.toAnyObject() }.reduce([:]) { $0.merging($1) { (current, _) in current } }
    }

    init(id:Int) {
        self.id = id
        self.communities = []
        self.ref = nil
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int,
              let communities = value["ommunities "] as? [FirebaseCommunity] else {
            return nil
        }
        self.id = id
        self.communities = communities
        self.ref = snapshot.ref
    }

    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "communities": toFireBase
        ]
    }
}

final class FirebaseCommunity {
    let name: String
    let id: Int
    let ref: DatabaseReference?

    init(name: String, id: Int) {
        self.name = name
        self.id = id
        self.ref = nil
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let name = value["name"] as? String,
              let id = value["id"] as? Int else {
            return nil
        }
        self.name = name
        self.id = id
        self.ref = snapshot.ref
    }

    func toAnyObject() -> [String: Any] {
        return [
            "name": name,
            "id": id
        ]
    }
}
