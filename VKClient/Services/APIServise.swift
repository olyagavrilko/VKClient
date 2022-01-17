//
//  APIServise.swift
//  VKClient
//
//  Created by Olya Ganeva on 30.06.2021.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
    case notCorrectUrl
    case `default`
}

final class APIService {

    let baseURL = "https://api.vk.com/method"
    let token = Session.shared.token
    let clientID = Session.shared.userId
    private let version = "5.131"

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

final class FetchDataOperation: AsyncOperation {

    private let url: String
    private let method: HTTPMethod
    private let parameters: Parameters

    private lazy var request = AF.request(url, method: method, parameters: parameters)

    var data: Data?

    init(url: String, method: HTTPMethod, parameters: Parameters) {
        self.url = url
        self.method = method
        self.parameters = parameters
        super.init()
    }

    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }

    override func cancel() {
        request.cancel()
        super.cancel()
    }
}

final class ParseDataOperation<T: Decodable>: Operation {

    private let data: Data
    var model: T?

    init(data: Data) {
        self.data = data
        super.init()
    }

    override func main() {
        model = try? JSONDecoder().decode(T.self, from: data)
    }
}

class AsyncOperation: Operation {

    enum State: String {
        case ready
        case executing
        case finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
}
