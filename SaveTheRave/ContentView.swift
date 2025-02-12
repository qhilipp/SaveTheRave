//
//  ContentView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@Observable
class ViewModel {
	
	var profile: Profile?
	var showProfileEditor = false
	var showWelcomePipeline = false
	
	func fetchProfile() {
		guard let _ = UserDefaults.standard.string(forKey: "token") else {
			showWelcomePipeline = true
			return
		}
		
		GetUserEndpoint()
			.sendRequest { result in
				switch result {
					case .success(let data):
						self.profile = Profile.load(from: data)
					case .failure(let error):
						print(error)
				}
			}
	}
	
	func logout() {
		UserDefaults.standard.removeObject(forKey: "token")
		profile = nil
		showWelcomePipeline = true
	}
	
}

struct ContentView: View {
	
	@State var vm = ViewModel()
	
	init() {
		vm.fetchProfile()
	}
	
	var body: some View {
		if let profile = vm.profile {
			TabView {
				Tab("Explore", systemImage: "party.popper.fill") {
					PartiesView()
				}
				Tab("Connections", systemImage: "person.3.fill") {
					ConnectionsView()
				}
				Tab("QR-Code", systemImage: "qrcode.viewfinder") {
					QRGeneratorView()
				}
			}
			.environment(profile)
			.environment(vm)
			.onAppear {
				UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
					if let error = error {
						print("Error requesting notification permission: \(error)")
					} else if granted {
						UserDefaults.standard.set(true, forKey: "notificationPermission")
					} else {
						print("Notification permission denied.")
					}
				}
			}
		} else if !vm.showWelcomePipeline {
			VStack {
				ProgressView()
					.progressViewStyle(.circular)
				Text("Loading...")
			}
		} else {
			Button("This should not be shown") {
				vm.showWelcomePipeline = true
			}
			.sheet(isPresented: $vm.showWelcomePipeline) {
				WelcomePipelineView() {
					vm.fetchProfile()
				}
				.interactiveDismissDisabled(true)
			}
		}
	}
}

#Preview {
	ContentView()
}
