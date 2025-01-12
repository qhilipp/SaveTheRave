//
//  GetRelevantPartiesEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct GetRelevantPartiesEndpoint: Endpoint {
	let path = "app/party/relevants"
	let method = "GET"
	var headers: [String: String]
	
	init() {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
	}
}
