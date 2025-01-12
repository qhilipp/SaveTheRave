//
//  AssignToItemEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

struct AssignToItemEndpoint: Endpoint {
	let path = "app/item/assign"
	let method = "POST"
	let parameters: [String: Any]?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init(itemId: Int) {
		self.headers["Authorization"] = UserDefaults.standard.string(forKey: "token")
		self.parameters = [
			"item_id": itemId
		]
	}
}
