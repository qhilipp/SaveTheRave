//
//  ProfileDetailView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ProfileDetailView: View {
	
	var profile: Profile
	@State var friendStatus: FriendStatus = .unknown
	
	var requestText: String {
		switch friendStatus {
			case .friend, .unknown:
				"..."
			case .noFriend:
				"Request"
			case .pending:
				"Pending"
		}
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			ScrollView {
				VStack(alignment: .leading) {
					profile.picture
						.resizable()
						.scaledToFill()
						.frame(height: 300)
						.frame(maxWidth: .infinity, maxHeight: 300)
					
					Text(profile.fullName)
						.bold()
						.font(.largeTitle)
					
					genderBadge
					
					if let phoneNumber = profile.phoneNumber {
						ContactLinkView(contactLink: .phone(phoneNumber: phoneNumber))
					}
					
					if let instagram = profile.instagram {
						ContactLinkView(contactLink: .website(url: profile.instagramURL, name: instagram))
					}
					
					ForEach(profile.friends, id: \.self) { friend in
						ProfileListEntryView(profileId: friend)
					}
				}
			}
			
			if friendStatus != .friend {
				ConfirmationButton(requestText) {
					RequestFriendEndpoint(id: profile.id)
						.sendRequest { _ in
							fetchFriendStatus()
						}
				}
				.disabled([.unknown, .pending].contains(friendStatus))
				.padding()
			}
		}
		.padding()
		.onAppear {
			fetchFriendStatus()
		}
	}
	
	@ViewBuilder
	var genderBadge: some View {
		Text(profile.gender.description)
			.foregroundStyle(profile.gender.color)
			.bold()
			.padding(.horizontal, 7)
			.padding(.vertical, 4)
			.background(profile.gender.color.opacity(0.3))
			.clipShape(RoundedRectangle(cornerRadius: 4))
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
	ProfileDetailView(profile: .philipp)
}
