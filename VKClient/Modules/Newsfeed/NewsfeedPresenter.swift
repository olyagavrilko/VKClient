//
//  NewsfeedPresenter.swift
//  VKClient
//
//  Created by Olya Ganeva on 24.12.2021.
//

import Foundation

final class NewsfeedPresenter {

    private let networkService = NewsfeedNetworkService()

    func loadData() {
        networkService.fetchNews() { result in
            
        }
    }
}
