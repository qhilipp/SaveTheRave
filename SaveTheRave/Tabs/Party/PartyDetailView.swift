//
//  PartyDetailView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct PartyDetailView: View {
	
	@State var party: Party
	@State var profile: Profile
	
    var body: some View {
		ZStack(alignment: .bottom) {
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
					
					ScrollView(.horizontal) {
						HStack {
							ForEach(Array(party.items.keys).sorted(), id: \.self) { key in
								ItemObtainmentView(profile: profile, item: key, obtainer: party.items[key]!)
							}
						}
					}
					
					ForEach(party.attendees) { attendee in
						ProfileListEntryView(profile: attendee)
					}
					
				}
			}
			ConfirmationButton("Join") {
				
			}
			.padding(.bottom)
			.padding(.bottom)
		}
		.padding()
		.ignoresSafeArea()
    }
}

#Preview {
	PartyDetailView(party: .dummy, profile: .dummy)
}
