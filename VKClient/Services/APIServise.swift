//
//  APIServise.swift
//  VKClient
//
//  Created by Olya Ganeva on 30.06.2021.
//

import Alamofire
import Foundation

struct User {

}

final class APIService {

    private let baseURL = "https://api.vk.com/method"
    private let token = Session.shared.token
    private let clientID = Session.shared.userId
    private let version = "5.21"

    func getFriends(completion: ([User]) -> ()) {

        let url = baseURL + "/friends.get"

        let parameters: Parameters = [
            "user_id": clientID,
            "order": "name",
            "count": 50,
            "fields": "photo_100",
            "access_token": Session.shared.token,
            "v": version
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
        completion([])
    }

    func getPhotos() {

        let url = baseURL + "/photos.get"

        let parameters: Parameters = [
            "owner_id": "199549688",
            "album_id": "profile",
            "rev": 1,
            "access_token": Session.shared.token,
            "v": "5.77"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }

    func getGroups() {

        let url = baseURL + "/groups.get"

        let parameters: Parameters = [
            "user_id": "199549688",
            "extended": 1,
            "access_token": Session.shared.token,
            "v": "5.124"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }

    func searchGroups() {

        let url = baseURL + "/groups.search"

        let parameters: Parameters = [
            "q": "Музыка",
            "type": "group",
            "count": 2,
            "access_token": Session.shared.token,
            "v": "5.124"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }
}
