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
    @State private var showPassword: Bool = false
    let action: () -> Void
    
    var isLoginButtonDisabled: Bool {
        [userName, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Title
                Text("Welcome Back")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                // Login form
                VStack(spacing: 15) {
                    // Username field
                    TextField("Username", text: $userName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.none)
                    
                    // Password field with toggle
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(CustomTextFieldStyle())
                }
                .padding(.horizontal, 25)
                
                // Login button
                Button(action: performLogin) {
                    Text("Log in")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            isLoginButtonDisabled ?
                            Color.gray :
                            Color.blue
                        )
                        .cornerRadius(12)
                }
                .disabled(isLoginButtonDisabled)
                .padding(.horizontal, 25)
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
    
    private func performLogin() {
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

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    LoginView() {}
}


/*
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
*/
