//
//  PartyEditorView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct PartyEditorView: View {
	
	@Environment(\.dismiss) var dismiss
	@Environment(Profile.self) var profile: Profile
	@State var party: Party = .dummy
	@State var newItem = ""
	
    var body: some View {
		Form {
			Section {
				PhotoPicker($party.pictureData) { image in
					if let image {
						image
							.resizable()
							.aspectRatio(4/3, contentMode: .fill)
							.clipped()
							.listRowInsets(EdgeInsets())
					} else {
						Text("Choose image")
					}
				}
			}
			
			Section {
				TextField("Title", text: $party.title)
				TextField("Description", text: $party.description)
				TextField("Location", text: $party.location)
				DatePicker("Date", selection: $party.date, displayedComponents: [.date, .hourAndMinute])
			}
			
			Section("Items") {
				TextField("Item that someone should bring", text: $newItem)
					.onSubmit {
						withAnimation {
							party.items[newItem] = Optional(Optional(nil))
							newItem = ""
						}
					}
				
				List {
					ForEach(Array(party.items.keys).sorted(), id: \.self) { item in
						Text(item)
							.padding()
							.transition(AnyTransition.scale)
					}
					.onDelete(perform: deleteItems(at:))
				}
			}
			
			Section {
				TextField("Spotify playlist link", text: Binding(get: {
					party.spotify ?? ""
				}, set: { newValue in
					if newValue.isEmpty {
						party.spotify = nil
					} else {
						party.spotify = newValue
					}
				}))
			}
			
			ConfirmationButton("Create") {
				CreatePartyEndpoint(profile: profile, party: party)
					.sendRequest { _ in
						dismiss()
					}
			}
			.listRowInsets(EdgeInsets())
		}
    }
	
	func deleteItems(at indexSet: IndexSet) {
		withAnimation {
			let items = Array(party.items.keys).sorted()
			let itemsToRemove = indexSet.map { items[$0] }
			
			for item in itemsToRemove {
				party.items.removeValue(forKey: item)
			}
		}
	}
	
}

#Preview {
	PartyEditorView()
		.environment(Profile.dummy)
}
