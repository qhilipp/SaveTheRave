//
//  ContentView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ContentView: View {
	
	@State var profile: Profile
	@State var showProfileEditor = false
	@State var showWelcomePipeline = true
	
	var body: some View {
		TabView {
			Tab("Explore", systemImage: "party.popper.fill") {
				Text("Coming soon ⏰")
			}
			Tab("Connections", systemImage: "person.3.fill") {
				ConnectionsView(profile: profile)
			}
		}
		.sheet(isPresented: $showWelcomePipeline) {
			WelcomePipelineView()
				.interactiveDismissDisabled(true)
		}
	}
}

#Preview {
	ContentView(profile: .dummy)
}
