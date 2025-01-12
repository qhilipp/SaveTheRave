//
//  GetUserEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct GetUserEndpoint: Endpoint {
	let path = "app/user"
	let method = "GET"
	var headers: [String: String]

	init() {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
	}
}
