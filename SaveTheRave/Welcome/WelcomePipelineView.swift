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
	let action: () -> Void
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack(path: $path) {
			welcomeView
			.navigationDestination(for: WelcomePage.self) { page in
				switch page {
					case .welcome: welcomeView
					case .register: registerView
					case .login: loginView
				}
			}
		}
	}
	
	var welcomeView: some View {
		WelcomeView {
			path.append(WelcomePage.register)
		} loginAction: {
			path.append(WelcomePage.login)
		}
	}
		
	var registerView: some View {
		ProfileEditorView(profile: $profile, confirmationText: "Register") {
			CreateUserEndpoint(profile: profile, password: password)
				.sendRequest { result in
				switch result {
					case .success(let data):
						if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
							if let token = jsonObject["token"] as? String {
								UserDefaults.standard.set("Token \(token)", forKey: "token")
								action()
							}
						}
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
	
	var loginView: some View {
		LoginView {
			action()
		}
	}
}

enum WelcomePage {
	case welcome
	case register
	case login
}

#Preview {
	WelcomePipelineView() {}
}
