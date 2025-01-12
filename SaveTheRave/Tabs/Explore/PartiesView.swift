//
//  PartiesView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@Observable
class PartiesViewModel {
	var joinableParties: [Party]?
	var searchTerm = ""
	var showAddParty = false
}

struct PartiesView: View {
	
	@Environment(Profile.self) var profile: Profile
	@State var vm = PartiesViewModel()
	
	var searchResults: [Party]? {
		if let joinableParties = vm.joinableParties {
			if vm.searchTerm.isEmpty {
				joinableParties
			} else {
				joinableParties.filter { $0.fits(searchTerm: vm.searchTerm) }
			}
		} else {
			nil
		}
	}
	
	init() {
		fetchJoinableParties()
	}
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					if let joinableParties = searchResults {
						ForEach(joinableParties) { party in
							NavigationLink(value: party) {
								PartyListEntryView(party: party)
							}
							.buttonStyle(PlainButtonStyle())
						}
						.searchable(text: $vm.searchTerm)
					} else {
						ProgressView()
							.progressViewStyle(.circular)
					}
				}
				.padding(.horizontal)
			}
			.refreshable {
				fetchJoinableParties()
			}
			.navigationDestination(for: Party.self) { party in
				PartyDetailView(party: party, profile: profile)
			}
			.navigationTitle("Explore")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					ProfileEditorIcon(profile: profile)
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						vm.showAddParty = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $vm.showAddParty) {
				PartyEditorView()
			}
			.onChange(of: vm.showAddParty) { oldValue, newValue in
				if !newValue {
					fetchJoinableParties()
				}
			}
		}
	}
	
	func fetchJoinableParties() {
		GetRelevantPartiesEndpoint()
			.sendRequest { result in
				switch result {
					case .success(let data):
						vm.joinableParties = []
						if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
							for item in jsonArray {
								do {
									let partyData = try JSONSerialization.data(withJSONObject: item, options: [])
									let party = Party.load(from: partyData)
									vm.joinableParties?.append(party!)
									print(party!)
								} catch {
									print("Fehler beim Umwandeln des Elements in Data: \(error)")
								}
							}
						}
					case .failure(let error):
						print(error)
				}
			}
	}
}

#Preview {
	PartiesView()
}
