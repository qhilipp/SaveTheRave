//
//  FriendStatusEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

struct FriendStatusEndpoint: Endpoint {
	let path = "user/are_friends"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String]
	
	init(id: Int) {
		self.headers = ["Content-Type": "application/json"]
		self.parameters = [
			"id": id
		]
	}
}
