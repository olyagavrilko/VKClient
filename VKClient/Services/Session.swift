//
//  Session.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import Foundation

final class Session {

    static let shared = Session()

    private init() {}

    var token = ""
    var userId = ""
}
