//
//  GroupsAdapter.swift
//  VKClient
//
//  Created by Olya Ganeva on 16.02.2022.
//

import Foundation

final class GroupsAdapter {

    let apiService = APIService()
    private var completion: (([Group]) -> Void)?

    func getGroups(completion: @escaping ([Group]) -> Void) {
        self.completion = completion
        apiService.getGroupsForAdapter(delegate: self)
    }
}

extension GroupsAdapter: ApiGroupsDelegate {

    func returnGroups(_ groups: [Group]) {
        completion?(groups)
    }
}
