//
//  ProfileEditorIcon.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ProfileEditorIcon: View {
	
	@State var profile: Profile
	@State var showProfileEditor = false
	
	var body: some View {
		profile.picture
			.resizable()
			.scaledToFill()
			.frame(width: 30, height: 30)
			.clipShape(Circle())
			.onTapGesture {
				showProfileEditor.toggle()
			}
			.sheet(isPresented: $showProfileEditor) {
				ProfileEditorView(profile: $profile) {
				} extraInput: {
					Group {
						Section("Friend requests") {
							ForEach(profile.friendRequests.sorted(), id: \.self) { profileId in
								ProfileListEntryView(profileId: profileId, with: .accept) {
									fetchProfile()
								}
							}
							.onDelete { indexSet in
								delete(at: indexSet)
							}
						}
						Section("Friends") {
							ForEach(profile.friends.sorted(), id: \.self) { profileId in
								ProfileListEntryView(profileId: profileId, with: .none) {
									fetchProfile()
								}
							}
						}
					}
				}
			}
			.onAppear {
				fetchProfile()
			}
	}
	
	func delete(at indexSet: IndexSet) {
		for index in indexSet {
			decline(friend: profile.friendRequests.sorted()[index])
		}
	}
	
	func decline(friend id: Int) {
		DeclineFriendEndpoint(id: id)
			.sendRequest { result in
				profile.friendRequests.removeAll(where: { $0 == id })
			}
	}
	
	func fetchProfile() {
		GetUserByIdEndpoint(id: profile.id)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						self.profile = .load(from: jsonObject)
					}
				}
			}
	}
}

#Preview {
	ProfileEditorIcon(profile: .dummy)
}
