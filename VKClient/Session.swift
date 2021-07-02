//
//  Session.swift
//  VKClient
//
//  Created by Olya Ganeva on 22.06.2021.
//

import Foundation

final class Session {

    private init() {}

    static let shared = Session()

    var token: String = ""
    var userId: Int = 0
}
