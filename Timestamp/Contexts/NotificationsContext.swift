//
//  NotificationsContext.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.19.
//

import Foundation
import SwiftUI
import UserNotifications

@Observable
class NotificationsContext: NSObject, UNUserNotificationCenterDelegate {
    private(set) var notificationClickCount = 0
    
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
        await MainActor.run {
            notificationClickCount += 1
        }
    }
}
