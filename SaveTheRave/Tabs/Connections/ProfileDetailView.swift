//
//  ProfileDetailView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ProfileDetailView: View {
	
	var profile: Profile
	
	var body: some View {
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
				
				ForEach(profile.friends) { friend in
					ProfileListEntryView(profile: friend)
				}
				
				ConfirmationButton("Request") {
					
				}
			}
			.padding()
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
	
}

#Preview {
	ProfileDetailView(profile: .philipp)
}
