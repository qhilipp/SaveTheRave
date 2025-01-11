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
}
