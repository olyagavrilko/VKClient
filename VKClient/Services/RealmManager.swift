//
//  RealmManager.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.12.2021.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm

    private init?() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        print(realm.configuration.fileURL ?? "")
        self.realm = realm
    }

    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }

    func add<T: Object>(object: [T]) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }

    func update<T: Object>(
        type: T,
        primaryKeyValue: Any,
        setNewValue: Any,
        field: String
    ) throws {
        try realm.write {
            guard let primaryKey = T.primaryKey() else {
                print("No primaryKey for object \(T.self)")
                return
            }
            let target = realm.objects(T.self).filter("\(primaryKey) = %@", primaryKeyValue)
            target.setValue(setNewValue, forKey: "\(field)")
        }
    }

    func getObjects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }

    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
