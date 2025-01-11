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
	
	var id: String
	var name: String
	var date: Date
	var creator: Profile
	var description: String
	var location: String
	var friendDepth: Int
	var pictureData: Data?
	var items: [String: Profile?]
	var spotify: String?
	
	var picture: Image {
		if let picture = pictureData?.image {
			picture
		} else if let picture = creator.pictureData {
			picture.image!
		} else {
			Image("party")
		}
	}
	
	init(id: String, name: String, date: Date, creator: Profile, description: String, location: String, friendDepth: Int, pictureData: Data?, items: [String : Profile?]) {
		self.id = id
		self.name = name
		self.date = date
		self.creator = creator
		self.description = description
		self.location = location
		self.friendDepth = friendDepth
		self.pictureData = pictureData
		self.items = items
	}
}

extension Party {
	
	static var empty: Party {
		Party(id: "", name: "", date: .now, creator: .empty, description: "", location: "", friendDepth: 0, pictureData: nil, items: [:])
	}
	
	static var dummy: Party {
		.philippsBirthday
	}
	
	static var dummies: [Party] {
		[.philippsBirthday, .endOfQuarter]
	}
	
	static var philippsBirthday: Party {
		Party(id: "123456789", name: "Philipp's 21st", date: Date(timeIntervalSince1970: 1743278400), creator: .philipp, description: "Another year, another party, this time and for the first time using the new best way to organize parties: with SaveTheRave!", location: "Philipp's Home", friendDepth: 2, pictureData: UIImage(named: "philippParty")?.pngData(), items: ["Bacardí Razz": nil, "Chicken with Rice 💪": .sven])
	}
	
	static var endOfQuarter: Party {
		Party(id: "987654321", name: "End of Quarter Party", date: Date(timeIntervalSince1970: 1742589000), creator: .tyler, description: "Let's celebrate the end of the quarter", location: "6655 Del Playa", friendDepth: 1, pictureData: nil, items: [:])
	}
	
}

extension Party: Equatable, Hashable {
	
	static func == (lhs: Party, rhs: Party) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(name)
		hasher.combine(creator)
		hasher.combine(location)
	}
}

extension Party {
	
	func fits(searchTerm: String) -> Bool {
		creator.fits(searchTerm: searchTerm) || name.contains(searchTerm) || location.contains(searchTerm) || date.description.contains(searchTerm)
	}
}
