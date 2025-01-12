//
//  GetUserByIdEndpoint.swift
//  SaveTheRave
//
//  Created by Julian Springer on 12.01.25.
//

import Foundation

struct GetUserByIdEndpoint: Endpoint {
    var path = "app/user"
    let method = "GET"
    var headers: [String: String]

    init(id: Int) {
        path = "\(path)/\(id)"
        self.headers = [
            "Authorization": UserDefaults.standard.string(forKey: "token")!,
            "Content-Type": "application/json"
        ]
    }
}
