//
//  DateExtension.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

extension Date {
	var iso8601String: String {
		let formatter = ISO8601DateFormatter()
		return formatter.string(from: self)
	}
}

extension Date? {
	
	var formatted: String {
		guard let date = self else { return "null" }
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		return dateFormatter.string(from: date)
	}
	
}
