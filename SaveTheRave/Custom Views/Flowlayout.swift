//
//  Flowlayout.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct FlowLayout<Content: View>: View {
	@Binding var items: [String]
	let content: (String) -> Content
	
	var body: some View {
		GeometryReader { geometry in
			self.generateContent(in: geometry.size)
		}
	}
	
	private func generateContent(in size: CGSize) -> some View {
		var width: CGFloat = 0
		var height: CGFloat = 0
		
		return ZStack(alignment: .topLeading) {
			ForEach(items, id: \.self) { item in
				self.content(item)
					.padding(4)
					.alignmentGuide(.leading, computeValue: { d in
						if abs(width - d.width) > size.width {
							width = 0
							height -= d.height
						}
						let result = width
						if item == self.items.last {
							width = 0
						} else {
							width -= d.width
						}
						return result
					})
					.alignmentGuide(.top, computeValue: { _ in
						let result = height
						if item == self.items.last {
							height = 0
						}
						return result
					})
			}
		}
		.frame(height: abs(height))
	}
}

#Preview {
	FlowLayout(items: .constant(["Item1", "Item2", "Very very long item name", "I", "Another one"])) { item in
		Text(item)
	}
}
