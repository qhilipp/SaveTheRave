//
//  WelcomePipelineView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct WelcomePipelineView: View {
	
	@State var path = NavigationPath()
	@State var profile: Profile = .philipp
	@State var password: String = ""
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
		ProfileEditorView(profile: $profile, confirmationText: "Register") {
			CreateUserEndpoint(profile: profile, password: password)
				.sendRequest { result in
				switch result {
					case .success(let data):
						print(String(data: data, encoding: .utf8)!)
					case .failure(let error):
						print(error)
				}
			}
			dismiss()
		} extraInput: {
			Section("Security") {
				SecureField("Password", text: $password)
			}
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
