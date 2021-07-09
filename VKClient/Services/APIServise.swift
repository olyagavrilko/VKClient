//
//  APIServise.swift
//  VKClient
//
//  Created by Olya Ganeva on 30.06.2021.
//

import Alamofire
import Foundation

final class APIService {

    private let baseURL = "https://api.vk.com/method"
    private let token = Session.shared.token
    private let clientID = Session.shared.userId
    private let version = "5.21"

    func getFriends(completion: @escaping ([User]) -> ()) {

        let url = baseURL + "/friends.get"

        let parameters: Parameters = [
            "user_id": clientID,
            "order": "name",
            "count": 50,
            "fields": "city, photo_100",
            "access_token": Session.shared.token,
            "v": version
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }
            print(data.prettyJSON as Any)

            let friendsResponse = try? JSONDecoder().decode(UsersResponse.self, from: data)

            guard let friends = friendsResponse?.response.items else {
                return
            }

            DispatchQueue.main.async {
                completion(friends)
            }
        }
    }

//    func getFriends(completion: ([User]) -> ()) {
//
//        let url = baseURL + "/friends.get"
//
//        let parameters: Parameters = [
//            "user_id": clientID,
//            "order": "name",
//            "count": 50,
//            "fields": "city, photo_100",
//            "access_token": Session.shared.token,
//            "v": version
//        ]
//
//        AF.request(url, method: .get, parameters: parameters).responseData { response in
//
//            guard let data = response.data else {
//                return
//            }
//            print(data.prettyJSON as Any)
//
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
//                return
//            }
//
//            let object = json as! [String: Any]
//            let response = object["response"] as! [String: Any]
//            let items = response["items"] as! [Any]
//
//            for userJson in items {
//                let userJson = userJson as! [String: Any]
//                let id = userJson["id"] as! Int
//                let lastName = userJson["last_name"] as! String
//                let city = userJson["city"] as! [String: Any]
//                let cityTitle = city["title"] as! String
//                let firstName = userJson["first_name"] as! String
//            }
//        }
//        completion([])
//    }















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
