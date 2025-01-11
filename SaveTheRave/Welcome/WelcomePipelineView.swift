//
//  WelcomePipelineView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct WelcomePipelineView: View {
	
	@State var path = NavigationPath()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack(path: $path) {
			welcomeView
			.navigationDestination(for: WelcomePage.self) { page in
				switch page {
					case .welcome: welcomeView
					case .register: registerView
				}
			}
		}
	}
	
	var welcomeView: some View {
		WelcomeView {
			path.append(WelcomePage.register)
		}
	}
		
	var registerView: some View {
		ProfileEditorView(profile: .empty, confirmationText: "Register") {
			dismiss()
		}
		.navigationTitle("Register")
	}
}

enum WelcomePage {
	case welcome
	case register
}

#Preview {
	WelcomePipelineView()
}