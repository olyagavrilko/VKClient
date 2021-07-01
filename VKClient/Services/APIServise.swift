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
}
