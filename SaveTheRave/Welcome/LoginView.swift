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
								UserDefaults.standard.set("", forKey: "token")
								action()
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
