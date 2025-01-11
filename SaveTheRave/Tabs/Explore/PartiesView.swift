//
//  PartiesView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct PartiesView: View {
	
	@State var profile: Profile
	@State var suggestions: [Party] = Party.dummies
	@State var searchTerm = ""
	
	var searchResults: [Party] {
		if searchTerm.isEmpty {
			suggestions
		} else {
			suggestions.filter { $0.fits(searchTerm: searchTerm) }
		}
	}
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					ForEach(suggestions) { party in
						NavigationLink(value: party) {
							PartyListEntryView(party: party)
						}
						.buttonStyle(PlainButtonStyle())
					}
					.searchable(text: $searchTerm)
				}
				.padding(.horizontal)
			}
			.navigationDestination(for: Party.self) { party in
				ProfileDetailView(profile: profile)
			}
			.navigationTitle("Explore")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					ProfileEditorIcon(profile: profile)
				}
			}
		}
	}
}

#Preview {
	PartiesView(profile: .dummy)
}
