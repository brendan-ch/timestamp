//
//  NotificationsContext.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import Foundation
import SwiftUI
import UserNotifications

@Observable
class NotificationsContext: NSObject, UNUserNotificationCenterDelegate {
    private var notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // MARK: Notification permissions
    
    func requestNotificationPermission() async throws {
        try await notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        )
    }
    
    func getNotificationPermissionStatus() async -> UNAuthorizationStatus {
        await notificationCenter.notificationSettings().authorizationStatus
    }
    
    // MARK: Notification sending
    func scheduleIfHasPermission(_ request: UNNotificationRequest) {
        // Checking for permission first avoids spamming the user with notifications if they give permission later
        Task {
            let status = await getNotificationPermissionStatus()
            if status == .authorized || status == .provisional {
                try? await notificationCenter.add(request)
            }
        }
    }
    
    // MARK: Responding to notification clicks
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // "Click" the status bar item
        // See https://stackoverflow.com/questions/74986904/how-do-i-show-the-menu-bar-window-programmatically-in-swiftui
        let statusItem = NSApp.windows.first?.value(forKey: "statusItem") as? NSStatusItem
        statusItem?.button?.performClick(nil)
        NSApplication.shared.activate()
    }
}
