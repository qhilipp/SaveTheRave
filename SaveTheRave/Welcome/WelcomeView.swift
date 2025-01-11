//
//  WelcomeView.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

struct WelcomeView: View {
	
	var action: () -> Void
	
	var body: some View {
		VStack {
			Text("Welcome to \nSave The Rave")
				.multilineTextAlignment(.center)
				.font(.system(.largeTitle, design: .rounded))
				.bold()
				.padding(.top)
			
			VStack(alignment: .leading) {
				FeatureView(title: "Connect with friends", subTitle: "Match the gradients by moving the Red, Green and Blue sliders for the left and right colors.", systemImage: "person.3")
				
				FeatureView(title: "Plan your rave", subTitle: "More precision with the steppers to get that 100 score.", systemImage: "fireworks")
				
				FeatureView(title: "Control who shows up", subTitle: "A detailed score and comparison of your gradient and the target gradient.", systemImage: "lock")
				
				Spacer()
				
				ConfirmationButton("Continue", action: action)
					.padding(.bottom)
			}
			.padding(.horizontal)
		}
	}
}

#Preview {
	WelcomeView() {}
}
