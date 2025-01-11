//
//  DataExtension.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation
import SwiftUI

extension Data {
	
	var image: Image? {
		if let uiImage = UIImage(data: self) {
			return Image(uiImage: uiImage)
		}
		return nil
	}
	
}
