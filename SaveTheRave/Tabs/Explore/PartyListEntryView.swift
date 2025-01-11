//
//  PartyListEntryView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct PartyListEntryView: View {
	
	@State var party: Party
	
    var body: some View {
		LabeledImage(party.picture) {
			Text(party.title)
				.font(.system(.title, design: .rounded, weight: .bold))
			Text(party.description)
				.foregroundStyle(.secondary)
		}
    }
}

#Preview {
	PartyListEntryView(party: .dummy)
}
