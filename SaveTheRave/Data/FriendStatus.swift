//
//  FriendStatus.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 12.01.2025.
//

enum FriendStatus {
	case friend
	case noFriend
	case pending
	case unknown
	
	init(from string: String) {
		switch string.lowercased() {
			case "true": self = .friend
			case "false": self = .noFriend
			case "pending": self = .pending
			default: self = .unknown
		}
	}
}
