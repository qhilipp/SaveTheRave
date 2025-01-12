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
	
	var confirmationPayload: (String, Endpoint) {
		party.attendees.contains(profile) ? ("Leave", LeavePartyEndpoint(partyId: party.id)) : ("Join", JoinPartyEndpoint(partyId: party.id))
	}
	
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
					
					ScrollView(.horizontal, showsIndicators: false) {
						HStack {
							ForEach(Array(party.items.keys).sorted(), id: \.self) { key in
								ItemView(profile: profile, party: party, item: key)
							}
						}
					}
					
					ForEach(party.attendees) { attendee in
						ProfileListEntryView(profileId: attendee.id)
							.transition(AnyTransition.scale)
					}
				}
			}
			
			ConfirmationButton(confirmationPayload.0) {
				confirmationPayload.1
					.sendRequest { result in
						if case .success(let data) = result {
							if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
								let newParticipants = jsonObject["participants"] as? [[String: Any]]
								withAnimation {
									party.attendees = newParticipants?.map { Profile.load(from: $0) } ?? []
								}
							}
						}
					}
			}
		}
		.padding()
    }
}

#Preview {
	PartyDetailView(party: .dummy, profile: .dummy)
}
