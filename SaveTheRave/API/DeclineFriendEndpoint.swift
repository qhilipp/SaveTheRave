//
//  DeclineFriendEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

struct DeclineFriendEndpoint: Endpoint {
	let path = "app/user/decline"
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
