//
//  UserSearchEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct UserSearchEndpoint: Endpoint {
	let path = "app/user/search"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String]
	
	init(userName: String) {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
		self.parameters = [
			"username": userName,
		]
	}
}
