//
//  NotificationEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

struct NotificationEndpoint: Endpoint {
	let path = "app/user/notifications"
	let method = "GET"
	var headers: [String: String]
	var debug: Bool { false }
	
	init() {
		self.headers = [
			"Authorization": UserDefaults.standard.string(forKey: "token")!,
			"Content-Type": "application/json"
		]
	}
}
