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
	var showWelcomePipeline = true
	
	func fetchProfile() {
		guard let token = UserDefaults.standard.string(forKey: "token") else {
			showWelcomePipeline = false
			return
		}
		
		GetUserEndpoint(token: token)
			.sendRequest { result in
				switch result {
					case .success(let data):
						self.profile = Profile.load(from: data)
					case .failure(let error):
						print(error)
				}
			}
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
					ConnectionsView(profile: profile)
				}
				Tab("QR-Code", systemImage: "qrcode.viewfinder") {
					QRGeneratorView()
				}
			}
			.environment(profile)
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
