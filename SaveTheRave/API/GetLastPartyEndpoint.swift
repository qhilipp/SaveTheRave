//
//  GetLastPartyEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct GetLastPartyEndpoint: Endpoint {
	let path = "/app/user/last_check_in/"
	let method = "GET"
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init() {
		self.headers["Authorization"] = UserDefaults.standard.string(forKey: "token")
	}
}
