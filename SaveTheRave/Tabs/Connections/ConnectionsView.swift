//
//  ConnectionsView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ConnectionsView: View {
	
	@State var profile: Profile
	@State var suggestions: [Profile] = Profile.dummies
	@State var searchTerm = ""
	
	var searchResults: [Profile] {
		if searchTerm.isEmpty {
			suggestions
		} else {
			suggestions.filter { $0.fits(searchTerm: searchTerm) }
		}
	}
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(suggestions) { profile in
					NavigationLink(value: profile) {
						ProfileListEntryView(profile: profile)
					}
				}
				.searchable(text: $searchTerm)
			}
			.navigationDestination(for: Profile.self) { profile in
				ProfileDetailView(profile: profile)
			}
			.navigationTitle("Connections")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					ProfileEditorIcon(profile: profile)
				}
			}
		}
	}
}

#Preview {
	ConnectionsView(profile: .dummy, suggestions: Profile.dummies)
}
