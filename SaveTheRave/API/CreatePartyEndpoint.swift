//
//  CreatePartyEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct CreatePartyEndpoint: Endpoint {
	let path = "app/party/create"
	let method = "POST"
	let body: Data?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init(profile: Profile, party: Party) {
		var items: [String: Any?] = [:]
		for item in party.items.keys {
			items[item] = Optional(Optional(nil))
		}

		let parameters: [String: Any] = [
			"name": party.title,
			"invitation_level": party.friendDepth,
			"time": party.date.formattedWithTime,
			"location": party.location,
			"white_list": [],
			"items": items,
			"spotify_link": party.spotify,
			"description": party.description
		]
		
		self.headers["Authorization"] = UserDefaults.standard.string(forKey: "token")
		self.body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
	}
}
