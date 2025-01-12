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
					Button {
						
					} label: {
						Image(systemName: "plus")
							.bold()
					}
				}
				Text("\(profile.userName)")
					.foregroundStyle(.secondary)
			}
		}
	}
}

#Preview {
	ProfileListEntryView(profile: .dummy)
}
