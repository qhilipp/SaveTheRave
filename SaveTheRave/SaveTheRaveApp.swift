//
//  SaveTheRaveApp.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import SwiftUI

@main
struct SaveTheRaveApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.onReceive(timer) { _ in
					guard UserDefaults.standard.bool(forKey: "notificationPermission") else { return }
					
					NotificationEndpoint()
						.sendRequest { result in
							if case .success(let data) = result {
								if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
									let notifications = jsonArray.map { Notification.load(from: $0) }
									for (index, notification) in notifications.enumerated() {
										scheduleNotification(notification, after: TimeInterval(index))
									}
								}
							}
						}
				}
        }
    }
	
	func scheduleNotification(_ notification: Notification, after delay: TimeInterval) {
		let notificationCenter = UNUserNotificationCenter.current()
			
		let content = UNMutableNotificationContent()
		content.title = notification.sender.fullName
		content.body = notification.message
		content.sound = .default
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay + 1, repeats: false)
		
		let request = UNNotificationRequest(identifier: "\(notification.id)", content: content, trigger: trigger)
		
		notificationCenter.add(request) { error in
			if let error = error {
				print("Error scheduling notification: \(error)")
			} else {
				print("Notification scheduled for \(notification.id): \"\(notification.message)\"")
			}
		}
	}
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		let center = UNUserNotificationCenter.current()
		center.delegate = self

		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				print("Error requesting notification permission: \(error)")
			} else if granted {
				UserDefaults.standard.set(true, forKey: "notificationPermission")
			} else {
				print("Notification permission denied.")
			}
		}

		return true
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.banner, .sound])
	}
}
