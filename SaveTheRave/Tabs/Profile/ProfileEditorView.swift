//
//  ProfileEditorView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ProfileEditorView<Content: View>: View {
	
	@Binding var profile: Profile
	@State var customGender = ""
	var confirmationText = "Done"
	var action: () -> Void
	var extraInput: () -> Content
	
	init(profile: Binding<Profile>, confirmationText: String = "Done", action: @escaping () -> Void, extraInput: (@escaping () -> Content) = { EmptyView() }) {
		self._profile = profile
		self.confirmationText = confirmationText
		self.action = action
		self.extraInput = extraInput
	}
	
	var body: some View {
		Form {
			Section {
				HStack(spacing: 20) {
					PhotoPicker($profile.pictureData) { image in
						profile.picture
							.resizable()
							.scaledToFill()
							.frame(width: 75, height: 75)
							.clipShape(Circle())
					}
					VStack {
						TextField("Username", text: $profile.userName)
						Divider()
						HStack {
							TextField("First name", text: $profile.firstName)
							TextField("Last name", text: Binding(get: {
								profile.lastName ?? ""
							}, set: { newValue in
								if newValue.isEmpty {
									profile.lastName = nil
								} else {
									profile.lastName = newValue
								}
							}))
						}
					}
				}
			}
			Section("Contact") {
				TextField("(123) 456-7890", text: Binding(get: {
					profile.phoneNumber ?? ""
				}, set: { newValue in
					if newValue.isEmpty {
						profile.phoneNumber = nil
					} else {
						profile.phoneNumber = newValue
					}
				}))
				.keyboardType(.phonePad)
				.onChange(of: profile.phoneNumber) {
					if let phoneNumber = profile.phoneNumber {
						profile.phoneNumber = phoneNumber.formatPhoneNumber()
					}
				 }
				TextField("Your Instagram name", text: Binding(get: {
					profile.instagram ?? ""
				}, set: { newValue in
					if newValue.isEmpty {
						profile.instagram = nil
					} else {
						profile.instagram = newValue
					}
				}))
			}
			Section("Personal information") {
				DatePicker("Your birthday", selection: Binding(get: {
					profile.birthday ?? Date()
				}, set: { newValue in
					profile.birthday = newValue
				}), displayedComponents: .date)
				
				Picker("Gender", selection: Binding(get: {
					profile.gender
				}, set: { newValue in
					profile.gender = newValue
					if case .custom(let name) = newValue {
						customGender = name
					}
				}
				)) {
					Text("Male").tag(Gender.male)
					Text("Female").tag(Gender.female)
					Text("Custom").tag(Gender.custom(name: ""))
					Text("Unknown").tag(Gender.unknown)
				}
			   .listRowSeparator(.hidden)
				
				if case .custom = profile.gender {
					TextField("Your gender", text: $customGender, onCommit: {
						profile.gender = .custom(name: "")
					})
				}
			}
			
			extraInput()
			
			ConfirmationButton(confirmationText) {
				if case .custom = profile.gender {
					profile.gender = .custom(name: customGender)
				}
				action()
			}
			.listRowInsets(EdgeInsets())
		}
	}
}

#Preview {
	ProfileEditorView(profile: .constant(.dummy)) {}
}
