//
//  CreateUserEndpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

struct CreateUserEndpoint: Endpoint {
	let url = URL(string: "http://169.231.139.207:8000/app/user/create")!
	let method = "POST"
	let body: Data?
	
	init(profile: Profile, password: String) {
		let parameters: [String: Any] = [
			"username": profile.userName,
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
