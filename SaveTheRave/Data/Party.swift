//
//  Party.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftData
import Foundation
import SwiftUICore
import UIKit

@Observable
class Party: Identifiable {
	
	var id: Int
	var title: String
	var date: Date
	var creator: Profile
	var description: String
	var location: String
	var friendDepth: Int
	var pictureData: Data?
	var items: [String: Profile?]
	var spotify: String?
	var attendees: [Profile]
	var maxAttendees: Int
	var checkedIn: [Profile]
	
	var picture: Image {
		if let picture = pictureData?.image {
			picture
		} else if let picture = creator.pictureData {
			picture.image!
		} else {
			Image("party")
		}
	}
	
	init(id: Int, name: String, date: Date, creator: Profile, description: String, location: String, friendDepth: Int, pictureData: Data?, items: [String : Profile?], attendees: [Profile], maxAttendees: Int, checkedIn: [Profile] = []) {
		self.id = id
		self.title = name
		self.date = date
		self.creator = creator
		self.description = description
		self.location = location
		self.friendDepth = friendDepth
		self.pictureData = pictureData
		self.items = items
		self.attendees = attendees
		self.maxAttendees = maxAttendees
		self.checkedIn = checkedIn
	}
}

extension Party {
	static func load(from data: Data) -> Party? {

		if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			
			var items: [String: Profile?] = [:]
			
			for item in jsonObject["items"] as! [[String: Any]] {
				let itemName = item["name"].safeString!
				
				if let broughtBy = item["brought_by"] as? [String: Any] {
					items[itemName] = Profile.load(from: broughtBy)
				} else {
					items[itemName] = Optional(Optional(nil))
				}
			}
			
			let party = Party(
				id: jsonObject["id"] as! Int,
				name: jsonObject["name"].safeString!,
				date: jsonObject["time"].safeString!.date,
				creator: Profile.load(from: jsonObject["host"] as! [String: Any]),
				description: jsonObject["description"].safeString ?? "",
				location: jsonObject["location"].safeString!,
				friendDepth: jsonObject["invitation_level"] as! Int,
				pictureData: nil,
				items: items,
				attendees: (jsonObject["participants"] as! [[String: Any]]).map { Profile.load(from: $0) },
				maxAttendees: jsonObject["max_people"] as! Int,
				checkedIn: (jsonObject["checked_in"] as! [[String: Any]]).map { Profile.load(from: $0) }
			)
			return party
		}

		return nil
	}
}

extension Party {
	
	static var empty: Party {
		Party(id: 0, name: "", date: .now, creator: .empty, description: "", location: "", friendDepth: 0, pictureData: nil, items: [:], attendees: [], maxAttendees: 1)
	}
	
	static var dummy: Party {
		.philippsBirthday
	}
	
	static var dummies: [Party] {
		[.philippsBirthday, .endOfQuarter]
	}
	
	static var philippsBirthday: Party {
		Party(id: 123456789, name: "Philipp's 21st", date: Date(timeIntervalSince1970: 1743278400), creator: .philipp, description: "Another year, another party, this time and for the first time using the new best way to organize parties: with SaveTheRave!", location: "Philipp's Home", friendDepth: 1, pictureData: UIImage(named: "philippParty")?.pngData(), items: ["Bacardí Razz": nil, "Chicken with Rice 💪": .sven], attendees: [.sven, .tyler, .philipp], maxAttendees: 50)
	}
	
	static var endOfQuarter: Party {
		Party(id: 987654321, name: "End of Quarter Party", date: Date(timeIntervalSince1970: 1742589000), creator: .tyler, description: "Let's celebrate the end of the quarter", location: "6655 Del Playa", friendDepth: 1, pictureData: nil, items: [:], attendees: [.sven], maxAttendees: 420)
	}
}

extension Party: Equatable, Hashable {
	
	static func == (lhs: Party, rhs: Party) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(title)
		hasher.combine(creator)
		hasher.combine(location)
	}
}

extension Party {
	
	func fits(searchTerm: String) -> Bool {
		creator.fits(searchTerm: searchTerm) || title.contains(searchTerm) || location.contains(searchTerm) || date.description.contains(searchTerm)
	}
}
