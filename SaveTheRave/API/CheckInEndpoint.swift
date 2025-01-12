//
//  JoinPartyEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct CheckInEndpoint: Endpoint {
	let path = "app/party/checkin"
	let method = "POST"
	let parameters: [String: Any]?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
    init(userId: String, partyId: Int) {
		self.headers["Authorization"] = UserDefaults.standard.string(forKey: "token")
		self.parameters = [
			"id": partyId,
            "user_id": Int(userId)!
		]
	}
}
