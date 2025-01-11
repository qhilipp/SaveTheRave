//
//  ContactLinkView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct ContactLinkView: View {
	
	var contactLink: ContactLink
	@State var showPhoneNumberSelection = false
	
	var body: some View {
		switch contactLink {
			case .phone(let phoneNumber):
				phoneNumberLink(for: phoneNumber)
			case .email(let emailAddress):
				emailLink(for: emailAddress)
			case .website(url: let url, name: let name):
				websiteLink(for: url, name: name)
		}
	}
	
	@ViewBuilder
	func phoneNumberLink(for phoneNumber: String) -> some View {
		if let telURL = URL(string: "text://\(phoneNumber)"), let smsURL = URL(string: "sms://\(phoneNumber)") {
			Button(phoneNumber) {
				showPhoneNumberSelection.toggle()
			}
			.underline()
			.confirmationDialog("Moin?", isPresented: $showPhoneNumberSelection) {
				Link(destination: telURL) {
					Label("Call", systemImage: "phone")
				}
				Link(destination: smsURL) {
					Label("Text", systemImage: "text.bubble")
				}
			}
		} else {
			Text(phoneNumber)
		}
	}
	
	@ViewBuilder
	func emailLink(for emailAddress: String) -> some View {
		if let url = URL(string: "mailto:\(emailAddress)") {
			Link(emailAddress, destination: url)
		} else {
			Text(emailAddress)
		}
	}
	
	@ViewBuilder
	func websiteLink(for url: URL?, name: String) -> some View {
		if let url {
			Link(name, destination: url)
		} else {
			Text(name)
		}
	}
}

enum ContactLink {
	case phone(phoneNumber: String)
	case email(emailAddress: String)
	case website(url: URL?, name: String)
}

#Preview {
	ContactLinkView(contactLink: .website(url: URL(string: "https://www.instagram.com/qhilipp.k/")!, name: "qhilipp.k"))
}
