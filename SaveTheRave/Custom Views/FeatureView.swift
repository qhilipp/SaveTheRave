//
//  FeatureView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct FeatureView: View {
	var title: String
	var subTitle: String
	var systemImage: String

	var body: some View {
		HStack(alignment: .center) {
			Image(systemName: systemImage)
				.resizable()
				.scaledToFit()
				.frame(maxWidth: 50, maxHeight: 50)
				.font(.largeTitle)
				.foregroundStyle(Color.accentColor)
				.padding()
				.accessibility(hidden: true)

			VStack(alignment: .leading) {
				Text(title)
					.font(.headline)
					.foregroundColor(.primary)
					.accessibility(addTraits: .isHeader)

				Text(subTitle)
					.font(.body)
					.foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding(.top)
	}
}

#Preview {
	FeatureView(title: "Connect with friends", subTitle: "Add your contacts to your friend list and share your rave", systemImage: "person.3")
}
