//
//  FriendsInRadiusEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

struct FriendsInRadiusEndpoint: Endpoint {
	let path = "app/user/level_friends"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String]
	
	init(level: Int) {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
		self.parameters = [
			"level": level
		]
	}
}
