//
//  Profile.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation
import SwiftUI

@Observable
class Profile: Identifiable, Codable {
	var id: Int
	var userName: String
	var firstName: String
	var lastName: String?
	var phoneNumber: String?
	var instagram: String?
	var birthday: Date?
	var gender: Gender
	var pictureData: Data?
	var friends: [Profile]
	
	var fullName: String {
		firstName + " " + (lastName ?? "")
	}
	
	var picture: Image {
		if let picture = pictureData?.image {
			picture
		} else {
			Image(systemName: "person.circle.fill")
		}
	}
	
	var instagramURL: URL? {
		if let instagram {
			URL(string: "https://www.instagram.com/\(instagram)/")
		} else {
			nil
		}
	}
	
	init(id: Int, userName: String, firstName: String, lastName: String? = nil, phoneNumber: String? = nil, instagram: String? = nil, birthday: Date? = nil, gender: Gender, pictureData: Data? = nil, friends: [Profile] = []) {
		self.id = id
		self.userName = userName
		self.firstName = firstName
		self.lastName = lastName
		self.phoneNumber = phoneNumber
		self.instagram = instagram
		self.birthday = birthday
		self.gender = gender
		self.pictureData = pictureData
		self.friends = friends
	}
}

extension Profile {
	static func load(from data: Data) -> Profile? {

		if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			let profile = Profile(
				id: jsonObject["id"] as! Int,
				userName: jsonObject["username"].safeString!,
				firstName: jsonObject["first_name"].safeString!,
				lastName: jsonObject["last_name"].safeString,
				phoneNumber: jsonObject["phone_number"].safeString,
				instagram: jsonObject["instagram"].safeString,
				birthday: jsonObject["birthday"].safeString.date,
				gender: .init(from: jsonObject["gender"].safeString),
				pictureData: nil,
				friends: []
			)
			return profile
		}

		return nil
	}
}

extension Profile {
	static var empty: Profile {
		Profile(id: 0, userName: "", firstName: "", gender: .unknown)
	}
	
	static var dummy: Profile {
		philipp
	}
	
	static var dummies: [Profile] {
		[tom, philipp, sven, tyler]
	}
	
	static var tom: Profile {
		Profile(id: 123456789, userName: "dasTom", firstName: "Tom", lastName: "Eitner", phoneNumber: "+49 123456789", birthday: Date(timeIntervalSince1970: 1090691414), gender: .male, pictureData: nil, friends: [])
	}
	
	static var philipp: Profile {
		Profile(id: 123, userName: "qhilipp", firstName: "Philipp", lastName: "Kathöfer", phoneNumber: "‭(805) 896-7985‬", instagram: "qhilipp.k", birthday: Date(timeIntervalSince1970: 1090692414), gender: .male, pictureData: UIImage(named: "philippParty")?.pngData(), friends: [sven, tyler, tom])
	}
	
	static var sven: Profile {
		Profile(id: 312, userName: "sven.stinkt", firstName: "Svehn", lastName: "Sperr", phoneNumber: "+49 987654321", birthday: Date(timeIntervalSince1970: 1090391414), gender: .male, pictureData: nil, friends: [])
	}
	
	static var tyler: Profile {
		Profile(id: 420420420, userName: "tyler.find.ich.geiler", firstName: "Tyler", lastName: "Marvort", phoneNumber: "+50 263847659", birthday: Date(timeIntervalSince1970: 1090680000), gender: .male, pictureData: nil, friends: [])
	}
}

extension Profile: Equatable, Hashable {
	
	static func == (lhs: Profile, rhs: Profile) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(firstName)
		hasher.combine(lastName)
		hasher.combine(phoneNumber)
	}
}

extension Profile {
	
	func fits(searchTerm: String) -> Bool {
		firstName.contains(searchTerm) || (lastName?.contains(searchTerm) ?? false) || (phoneNumber?.contains(searchTerm) ?? false)
	}
}
