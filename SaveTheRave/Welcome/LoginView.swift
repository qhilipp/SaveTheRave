//
//  LoginView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct LoginView: View {
	
	@State var userName: String = ""
	@State var password: String = ""
	let action: () -> Void
	
    var body: some View {
		VStack {
			TextField("User name", text: $userName)
			SecureField("Password", text: $password)
			ConfirmationButton("Log in") {
				LoginEndpoint(username: userName, password: password)
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
			}
		}
    }
}

#Preview {
	LoginView() {}
}
