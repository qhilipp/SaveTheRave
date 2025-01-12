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
					Section("Friend requests") {
						ForEach(profile.friendRequests.sorted(), id: \.self) { profileId in
							HStack {
								Text("\(profileId)")
								Button("Accept") {
									accept(friend: profileId)
								}
							}
						}
						.onDelete { indexSet in
							delete(at: indexSet)
						}
					}
				}
			}
	}
	
	func accept(friend id: Int) {
		AcceptFriendEndpoint(id: id)
			.sendRequest { result in
				profile.friendRequests.removeAll(where: { $0 == id })
				profile.friends.append(id)
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
}

#Preview {
	ProfileEditorIcon(profile: .dummy)
}
