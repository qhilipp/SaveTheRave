//
//  ProfileListEntryView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@Observable
class ProfileListEntryViewModel {
	var profile: Profile?
	var friendStatus = FriendStatus.unknown
	var actionType: ActionType
	
	init(profileId: Int, actionType: ActionType) {
		self.actionType = actionType
		GetUserByIdEndpoint(id: profileId)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						self.profile = .load(from: jsonObject)
					}
				}
			}
	}
}

struct ProfileListEntryView: View {
	
	@State var vm: ProfileListEntryViewModel
	
	init(profileId: Int, with actionType: ActionType = .request) {
		vm = ProfileListEntryViewModel(profileId: profileId, actionType: actionType)
	}
	
	var body: some View {
		HStack(alignment: .top) {
			(vm.profile?.picture ?? Image(systemName: "person.circle.fill"))
				.resizable()
				.scaledToFill()
				.frame(width: 50, height: 50)
				.clipShape(Circle())
			VStack(alignment: .leading) {
				HStack {
					Text(vm.profile?.fullName ?? "Loading")
					if [.unknown, .noFriend].contains(vm.friendStatus) && vm.actionType != .none {
						Button(vm.actionType.rawValue) {
							switch vm.actionType {
								case .request:
									requestFriend()
									break
								case .accept:
									acceptFriend()
									break
								case .none:
									break
							}
						}
						.disabled(vm.friendStatus == .unknown)
						.buttonStyle(.plain)
						.foregroundStyle(Color.accentColor)
					} else {
						Text(vm.friendStatus == .pending ? "Pending..." : "Friend")
							.foregroundStyle(.secondary)
					}
				}
				Text("\(vm.profile?.userName ?? "Loading")")
					.foregroundStyle(.secondary)
			}
		}
		.background(
			Group {
				if let profile = vm.profile {
					NavigationLink(destination: ProfileDetailView(profile: profile)) {
						EmptyView()
					}
					.buttonStyle(.plain)
					.opacity(0)
					.allowsHitTesting(false)
				} else {
					EmptyView()
				}
			}
		)
		.contentShape(Rectangle())
		.onAppear {
			fetchFriendStatus()
		}
	}
	
	func acceptFriend() {
		guard let profile = vm.profile else { return }
		AcceptFriendEndpoint(id: profile.id)
			.sendRequest { result in
				profile.friendRequests.removeAll(where: { $0 == profile.id })
				profile.friends.append(profile.id)
			}
	}
	
	func requestFriend() {
		guard let profileId = vm.profile?.id else { return }
		
		RequestFriendEndpoint(id: profileId)
			.sendRequest { _ in
				fetchFriendStatus()
			}
	}
	
	func fetchFriendStatus() {
		guard let profileId = vm.profile?.id else { return }
		
		FriendStatusEndpoint(id: profileId)
			.sendRequest { result in
				if case .success(let data) = result {
					if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						vm.friendStatus = FriendStatus(from: (jsonObject["are_friends"].safeString as String?) ?? "unknown")
					}
				}
			}
	}
	
}

enum ActionType: String {
	case request = "Request"
	case accept = "Accept"
	case none = ""
}

#Preview {
	ProfileListEntryView(profileId: Profile.dummy.id)
}
