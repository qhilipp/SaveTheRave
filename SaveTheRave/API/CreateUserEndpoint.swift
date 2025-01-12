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
	let parameters: [String: Any]?
	var headers: [String: String] = ["Content-Type": "application/json"]
	
	init(profile: Profile, password: String) {
		self.parameters = [
			"username": profile.userName,
			"first_name": profile.firstName,
			"last_name": profile.lastName ?? NSNull(),
			"password": password,
			"birthday": profile.birthday.formatted,
			"gender": profile.gender.description,
			"phone_number": profile.phoneNumber ?? NSNull(),
			"friends": [],
			"instagram": profile.instagram ?? NSNull()
		]
	}
}
