//
//  ItemView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ItemView: View {
	
	var profile: Profile
	var party: Party
	@State var item: String
	@State var obtainer: Profile? = nil
	
	var title: String {
		if let obtainer {
			"\(obtainer.fullName) brings:"
		} else {
			"Still needed:"
		}
	}
	
    var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 0) {
				Text(title)
					.font(.footnote)
					.foregroundStyle(.secondary)
				Text(item)
			}
			if let obtainer {
				obtainer.picture
					.resizable()
					.frame(width: 50, height: 50)
					.clipShape(.circle)
			} else {
				Button {
					AssignToItemEndpoint(itemName: item, partyId: party.id)
						.sendRequest { result in
							obtainer = profile
						}
				} label: {
					Image(systemName: "cart.badge.plus")
						.frame(width: 40, height: 40)
				}
				.buttonStyle(.bordered)
				.tint(.accentColor)
				.clipShape(.circle)
			}
		}
		.padding(10)
		.background(Color(.systemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
	ItemView(profile: .dummy, party: .dummy, item: "Bacardí Razz")
}
