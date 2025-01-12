//
//  GetUserEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct GetUserEndpoint: Endpoint {
	let path = "user"
	let method = "GET"
	let body: Data? = nil
	var headers: [String: String]
	
	init(token: String) {
		self.headers = [
			"Authorization": token,
			"Content-Type": "application/json"
		]
	}
}
