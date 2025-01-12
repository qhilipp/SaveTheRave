//
//  AcceptFriendEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

struct AcceptFriendEndpoint: Endpoint {
	let path = "app/user/accept"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String]
	
	init(id: Int) {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
		self.parameters = [
			"id": id
		]
	}
}
