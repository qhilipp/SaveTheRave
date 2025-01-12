//
//  CreateUserEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct CreateUserEndpoint: Endpoint {
	let path = "app/user/create"
	let method = "POST"
	let body: Data?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init(profile: Profile, password: String) {
		let parameters: [String: Any] = [
			"username": profile.userName,
			"first_name": profile.firstName,
			"last_name": profile.lastName,
			"password": password,
			"birthday": profile.birthday.formatted,
			"gender": profile.gender.description,
			"phone_number": profile.phoneNumber ?? NSNull(),
			"friends": [],
			"instagram": profile.instagram ?? NSNull()
		]
		
		self.body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
	}
}
