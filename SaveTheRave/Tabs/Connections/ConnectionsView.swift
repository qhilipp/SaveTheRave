//
//  ConnectionsView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@Observable
class ConnectionsViewModel {
	var suggestions: [Profile]?
	var searchTerm = ""
}

struct ConnectionsView: View {
	
	@Environment(Profile.self) var profile: Profile
	@State var vm = ConnectionsViewModel()
	
	var body: some View {
		NavigationStack {
			Group {
				if let suggestions = vm.suggestions {
					List(suggestions) { profile in
						NavigationLink {
							ProfileDetailView(profile: profile)
						} label: {
							ProfileListEntryView(profile: profile)
						}
					}
					.searchable(text: $vm.searchTerm)
					.onChange(of: vm.searchTerm) { oldValue, newValue in
						fetchSuggestions()
					}
					.refreshable {
						fetchSuggestions()
					}
				} else {
					ProgressView()
						.progressViewStyle(.circular)
				}
			}
			.navigationTitle("Connections")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					ProfileEditorIcon(profile: profile)
				}
			}
		}
		.onAppear {
			fetchSuggestions()
		}
	}
	
	func fetchSuggestions() {
		UserSearchEndpoint(userName: vm.searchTerm)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
						withAnimation {
							vm.suggestions = jsonArray.map { Profile.load(from: $0) }
						}
					}
				}
			}
	}
}

#Preview {
	ConnectionsView()
		.environment(Profile.dummy)
}
