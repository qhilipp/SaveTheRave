//
//  AnyExtension.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

extension Any? {
	var safeString: String? {
		guard let value = self, !(value is NSNull) else {
			return nil
		}
		return value as? String
	}
}
