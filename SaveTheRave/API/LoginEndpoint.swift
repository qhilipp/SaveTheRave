//
//  LoginEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct LoginEndpoint: Endpoint {
	let path = "api-token-auth"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String]
	
	init(username: String, password: String) {
		self.headers = ["Content-Type": "application/json"]
		self.parameters = [
			"username": username,
			"password": password
		]
	}
}
