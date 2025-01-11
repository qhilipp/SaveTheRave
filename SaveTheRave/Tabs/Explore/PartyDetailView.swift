//
//  PartyDetailView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct PartyDetailView: View {
	
	@State var party: Party
	
    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				party.picture
					.resizable()
					.frame(maxWidth: .infinity, maxHeight: 300)
					.scaledToFill()
				
				Text(party.title)
					.font(.system(.largeTitle, design: .rounded, weight: .bold))
				
				Text(party.description)
					.foregroundStyle(.secondary)
				
				
				
				ForEach(party.attendees) { attendee in
					ProfileListEntryView(profile: attendee)
				}
				
				ConfirmationButton("Join") {
					
				}
			}
			.padding()
		}
    }
}

#Preview {
	PartyDetailView(party: .dummy)
}
