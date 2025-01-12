//
//  StringExtension.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

extension String {
	
	func formatPhoneNumber() -> String {
		let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		
		let mask = "(XXX) XXX-XXXX"
		
		var result = ""
		var startIndex = cleanNumber.startIndex
		let endIndex = cleanNumber.endIndex
		
		for char in mask where startIndex < endIndex {
			if char == "X" {
				result.append(cleanNumber[startIndex])
				startIndex = cleanNumber.index(after: startIndex)
			} else {
				result.append(char)
			}
		}
		
		return result
	}
	
	var date: Date {
		Optional<Self>(self).date!
	}
}

extension String? {
	
	var date: Date? {
		guard let formatted = self else { return nil }
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.date(from: formatted)
	}
	
}
