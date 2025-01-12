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
	let body: Data?
	var headers: [String: String]
	
	init(username: String, password: String) {
		self.headers = [
			"Content-Type": "application/json"
		]
		
		let parameters: [String: Any] = [
			"username": username,
			"password": password
		]
		
		self.body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
	}
}
