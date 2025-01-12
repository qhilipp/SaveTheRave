//
//  DateExtension.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

extension Date {
	
	var formatted: String {
		Optional(self).formatted
	}
	
	var formattedWithTime: String {
		Optional(self).formattedWithTime
	}
}

extension Date? {
	
	var formatted: String {
		guard let date = self else { return "null" }
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		return dateFormatter.string(from: date)
	}
	
	var formattedWithTime: String {
		guard let date = self else { return "null" }
		
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		
		return dateFormatter.string(from: date)
	}
	
}
