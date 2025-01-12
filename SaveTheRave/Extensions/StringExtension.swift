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
		
		let dateFormats = [
			"yyyy-MM-dd'T'HH:mm:ssZ", // z.B. "2023-12-31T20:00:00Z"
			"yyyy-MM-dd",             // z.B. "2023-12-31"
			"MM/dd/yyyy",             // z.B. "12/31/2023"
			"dd-MM-yyyy",             // z.B. "31-12-2023"
			"yyyy/MM/dd",             // z.B. "2023/12/31"
			"MM-dd-yyyy"              // z.B. "12-31-2023"
		]
		
		for format in dateFormats {
			let formatter = DateFormatter()
			formatter.dateFormat = format
			formatter.locale = Locale(identifier: "en_US_POSIX")
			formatter.timeZone = TimeZone(secondsFromGMT: 0)
			
			if let date = formatter.date(from: formatted) {
				return date
			}
		}
		
		return nil
	}
	
}
