//
//  APIServise.swift
//  VKClient
//
//  Created by Olya Ganeva on 30.06.2021.
//

import Foundation
import Alamofire

struct User {

}

final class APIService {

    let baseURL = "https://api.vk.com/method"
    let token = Session.shared.token
    let clientID = Session.shared.userId
    let version = "5.21"

    func getFriends(completion: ([User]) -> ()) {

        let method = "/friends.get"

        let parameters: Parameters = [
            "user_id": clientID,
            "order": "name",
            "count": 50,
            "fields": "photo_100",
            "access_token": Session.shared.token,
            "v": version
        ]

        let url = baseURL + method

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
        completion([])
    }

    func getPhotos() {

        let method = "/photos.get"

        let parameters: Parameters = [
            "owner_id": "199549688",
            "album_id": "profile",
            "rev": 1,
            "access_token": Session.shared.token,
            "v": "5.77"
        ]

        let url = baseURL + method

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }

    func getGroups() {

        let method = "/groups.get"

        let parameters: Parameters = [
            "user_id": "199549688",
            "extended": 1,
            "access_token": Session.shared.token,
            "v": "5.124"
        ]

        let url = baseURL + method

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }

    func searchGroups() {

        let method = "/groups.search"

        let parameters: Parameters = [
            "q": "Музыка",
            "type": "group",
            "count": 2,
            "access_token": Session.shared.token,
            "v": "5.124"
        ]

        let url = baseURL + method

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            print(data.prettyJSON as Any)
        }
    }
}
