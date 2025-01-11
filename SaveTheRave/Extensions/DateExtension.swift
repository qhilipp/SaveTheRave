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
