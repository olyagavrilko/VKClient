//
//  NewsfeedNetworkService.swift
//  VKClient
//
//  Created by Olya Ganeva on 24.12.2021.
//

import Foundation

final class NewsfeedNetworkService {

    private let baseURL = "https://api.vk.com/method"
    private let token = Session.shared.token
    private let clientID = Session.shared.userId
    private let version = "5.131"

    func fetchNews(completion: @escaping (Result<NewsfeedResponse, NetworkError>) -> Void) {

        let url = baseURL + "/newsfeed.get"

        var components = URLComponents(string: url)!

        components.queryItems = [
            URLQueryItem(name: "filters", value: "post, photo"),
            URLQueryItem(name: "source_ids", value: "groups, pages"),
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]

        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in

            guard let data = data else {
                return completion(.failure(.default))
            }

            guard let newsfeedResponse = try? JSONDecoder().decode(NewsfeedResponse.self, from: data) else {
                return completion(.failure(.default))
            }

            completion(.success(newsfeedResponse))
        }
        task.resume()
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
