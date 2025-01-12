//
//  ProfileListEntryView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ProfileListEntryView: View {
	
	@State var profile: Profile
	@State var friendStatus: FriendStatus = .unknown
	
	var body: some View {
		HStack(alignment: .top) {
			profile.picture
				.resizable()
				.scaledToFill()
				.frame(width: 50, height: 50)
				.clipShape(Circle())
			VStack(alignment: .leading) {
				HStack {
					Text(profile.fullName)
					if [.unknown, .noFriend].contains(friendStatus) {
						Button {
							requestFriend()
						} label: {
							Image(systemName: "plus")
								.bold()
						}
						.disabled(friendStatus == .unknown)
						.buttonStyle(.plain)
						.foregroundStyle(Color.accentColor)
					} else {
						Text(friendStatus == .pending ? "Pending..." : "Friend")
							.foregroundStyle(.secondary)
					}
				}
				Text("\(profile.userName)")
					.foregroundStyle(.secondary)
			}
		}
		.background(
			NavigationLink(destination: ProfileDetailView(profile: profile)) {
				EmptyView()
			}
			.buttonStyle(.plain)
			.opacity(0)
			.allowsHitTesting(false)
		)
		.contentShape(Rectangle())
		.onAppear {
			fetchFriendStatus()
		}
	}
	
	func requestFriend() {
		RequestFriendEndpoint(id: profile.id)
			.sendRequest { _ in
				fetchFriendStatus()
			}
	}
	
	func fetchFriendStatus() {
		FriendStatusEndpoint(id: profile.id)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						friendStatus = FriendStatus(from: (jsonObject["are_friends"].safeString as String?) ?? "unknown")
					}
				}
			}
	}
	
}

#Preview {
	ProfileListEntryView(profile: .dummy)
}
