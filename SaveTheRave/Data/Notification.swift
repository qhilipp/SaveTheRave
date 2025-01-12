//
//  Notification.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

import Foundation

@Observable
class Notification {
	var id: Int
	var message: String
	var sender: Profile?
	
	init(id: Int, message: String, sender: Profile?) {
		self.id = id
		self.message = message
		self.sender = sender
	}
}

extension Notification {
	
	static func load(from jsonObject: [String: Any]) -> Notification {
		let profile: Profile?
		if let profileObject = jsonObject["sender"] {
			profile = Profile.load(from: profileObject as! [String: Any])
		} else {
			profile = nil
		}
		
		return Notification(
			id: jsonObject["id"] as! Int,
			message: jsonObject["message"].safeString!,
			sender: profile
		)
	}
}
