//
//  APIServise.swift
//  VKClient
//
//  Created by Olya Ganeva on 30.06.2021.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case `default`
}

final class APIService {

    private let baseURL = "https://api.vk.com/method"
    private let token = Session.shared.token
    private let clientID = Session.shared.userId
    private let version = "5.131"

    func getFriends(completion: @escaping (Result<[User], NetworkError>) -> Void) {

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
                return completion(.failure(.default))
            }

            let friendsResponse = try? JSONDecoder().decode(UsersResponse.self, from: data)

            guard let friends = friendsResponse?.response.items else {
                return
            }

            DispatchQueue.main.async {
//                completion(friends)
                completion(.success(friends))
            }
        }
    }

    func getPhotos(userId: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)  {

        let url = baseURL + "/photos.get"

        let parameters: Parameters = [
            "owner_id": userId,
            "album_id": "profile",
            "extended": 0,
            "count": 25,
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return completion(.failure(.default))
            }

            let photoResponse = try? JSONDecoder().decode(PhotoResponse.self, from: data)

            guard let photos = photoResponse?.response.items else {
                return
            }

            DispatchQueue.main.async {
                completion(.success(photos))
            }
        }
    }

    func getGroups(completion: @escaping (Result<[Group], NetworkError>) -> Void) {

        let url = baseURL + "/groups.get"

        let parameters: Parameters = [
            "user_id": "225909217",
            "extended": 1,
            "fields": "activity",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return completion(.failure(.default))
            }

            let groupsResponse = try? JSONDecoder().decode(GroupsResponse.self, from: data)

            guard let groups = groupsResponse?.response.items else {
                return
            }

            DispatchQueue.main.async {
                completion(.success(groups))
            }
        }
    }

    func searchGroups(text: String, completion: @escaping ([Group]) -> Void) {

        let url = baseURL + "/groups.search"

        let searchText = text

        let parameters: Parameters = [
            "q": searchText,
            "type": "group, page, event",
            "sort": 0,
            "count": 100,
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            let groupsResponse = try? JSONDecoder().decode(GroupsResponse.self, from: data)

            guard let groups = groupsResponse?.response.items else {
                return
            }

            DispatchQueue.main.async {
                completion(groups)
            }
        }
    }

    func joinGroup(id: Int, completion: @escaping (Int) -> Void) {

        let url = baseURL + "/groups.join"

        let parameters: Parameters = [
            "group_id": id,
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            let joinResponse = try? JSONDecoder().decode(JoinResponse.self, from: data)

            guard let response = joinResponse?.response else {
                return
            }

            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func leaveGroup(id: Int, completion: @escaping (Int) -> Void) {

        let url = baseURL + "/groups.leave"

        let parameters: Parameters = [
            "group_id": id,
            "access_token": Session.shared.token,
            "v": "5.131"
        ]

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else {
                return
            }

            let leaveResponse = try? JSONDecoder().decode(LeaveResponse.self, from: data)

            guard let response = leaveResponse?.response else {
                return
            }

            DispatchQueue.main.async {
                completion(response)
            }
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
