//
//  ConfirmationButton.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ConfirmationButton: View {
	
	var text: String
	var action: () -> Void
	
	init(_ text: String, action: @escaping () -> Void) {
		self.text = text
		self.action = action
	}
	
	var body: some View {
		Button {
			action()
		} label: {
			Text(text)
				.foregroundStyle(.white)
				.font(.headline)
				.padding()
				.frame(maxWidth: .infinity)
		}
		.background(Color.accentColor)
		.clipShape(RoundedRectangle(cornerRadius: 15))
	}
}

#Preview {
	ConfirmationButton("Confirm") {}
}
