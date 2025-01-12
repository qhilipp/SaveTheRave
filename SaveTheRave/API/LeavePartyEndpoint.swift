//
//  LeavePartyEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct LeavePartyEndpoint: Endpoint {
	let path = "app/party/leave"
	let method = "POST"
	let parameters: [String : Any]?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init(partyId: Int) {
		self.headers["Authorization"] = UserDefaults.standard.string(forKey: "token")
		self.parameters = [
			"party_id": partyId
		]
	}
}
