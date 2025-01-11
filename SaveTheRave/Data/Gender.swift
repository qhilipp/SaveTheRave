//
//  Gender.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation
import SwiftUI

enum Gender: CustomStringConvertible, Hashable {
	case male
	case female
	case custom(name: String)
	case unknown
	
	var description: String {
		switch self {
			case .male: "Male"
			case .female: "Female"
			case .custom(let name): name
			case .unknown: "Unknown"
		}
	}
	
	var color: Color {
		switch self {
			case .male: .blue
			case .female: .pink
			case .custom(_): .green
			case .unknown: .gray
		}
	}
}
