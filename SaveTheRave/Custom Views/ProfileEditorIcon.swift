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
				ProfileEditorView(profile: profile) {
					
				}
			}
	}
}

#Preview {
	ProfileEditorIcon(profile: .dummy)
}
