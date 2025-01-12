//
//  PartyEditorView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@Observable
class PartyEditorViewModel {
	var party: Party = .dummy
	var newItem = ""
	var peoplePreview: [Profile] = Profile.dummies
	
	func fetchFriendsInRadius() {
		FriendsInRadiusEndpoint(level: party.friendDepth)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
						withAnimation {
//							self.peoplePreview = jsonArray.map { Profile.load(from: $0) }
//							print("lsdkjflksdjf", self.peoplePreview)
						}
					}
				}
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

struct PartyEditorView: View {
	
	@Environment(\.dismiss) var dismiss
	@Environment(Profile.self) var profile: Profile
	@State var vm = PartyEditorViewModel()
	
    var body: some View {
		Form {
			Section {
				PhotoPicker($vm.party.pictureData) { image in
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
				TextField("Title", text: $vm.party.title)
				TextField("Description", text: $vm.party.description)
				TextField("Location", text: $vm.party.location)
				DatePicker("Date", selection: $vm.party.date, displayedComponents: [.date, .hourAndMinute])
			}
			
			Section("Items") {
				TextField("Item that someone should bring", text: $vm.newItem)
					.onSubmit {
						withAnimation {
							vm.party.items[vm.newItem] = Optional(Optional(nil))
							vm.newItem = ""
						}
					}
				
				List {
					ForEach(Array(vm.party.items.keys).sorted(), id: \.self) { item in
						Text(item)
							.transition(AnyTransition.scale)
					}
					.onDelete(perform: vm.deleteItems(at:))
				}
			}
			
			Section("Music") {
				TextField("Spotify playlist link", text: Binding(get: {
					vm.party.spotify ?? ""
				}, set: { newValue in
					if newValue.isEmpty {
						vm.party.spotify = nil
					} else {
						vm.party.spotify = newValue
					}
				}))
			}
			
			Section("Invite people") {
				TextField("Max number of people", text: Binding(get: {
					"\(vm.party.maxAttendees)"
				}, set: { newValue in
					vm.party.maxAttendees = Int(newValue)!
				}))
				.keyboardType(.numberPad)
				Picker("Invite...", selection: $vm.party.friendDepth) {
					ForEach(ReachOutLevel.allCases, id: \.self) { level in
						Text(level.description)
							.tag(level.rawValue)
					}
					.onChange(of: vm.party.friendDepth) {
						vm.fetchFriendsInRadius()
					}
					ForEach(vm.peoplePreview, id: \.id) { profile in
						ProfileListEntryView(profileId: profile.id)
					}
				}
			}
			
			ConfirmationButton("Create") {
				CreatePartyEndpoint(profile: profile, party: vm.party)
					.sendRequest { _ in
						dismiss()
					}
			}
			.listRowInsets(EdgeInsets())
		}
    }
	
	enum ReachOutLevel: Int, CustomStringConvertible, CaseIterable {
		case friendsOnly = 1
		case friendsOfFriends = 2
		case friendsOfFriendsOfFriends = 3
		case everyone = 7
		
		var description: String {
			switch self {
				case .friendsOnly: "Only friends"
				case .friendsOfFriends: "Friends of friends"
				case .friendsOfFriendsOfFriends: "Friends of friends of friends"
				case .everyone: "Public"
			}
		}
	}
	
}

#Preview {
	PartyEditorView()
		.environment(Profile.dummy)
}
