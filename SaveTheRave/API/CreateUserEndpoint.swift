//
//  CreateUserEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct CreateUserEndpoint: Endpoint {
	let path: String = "/app/user/create"
	let method: String = "POST"
	let headers: [String: String]? = [
		"Content-Type": "application/json"
	]
	let body: Data?
	
	init(profile: Profile, password: String) {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .iso8601

		do {
			let jsonData = try encoder.encode(profile)
			body = jsonData
		} catch {
			print("Fehler beim Kodieren: \(error)")
			body = nil
		}
	}
}
