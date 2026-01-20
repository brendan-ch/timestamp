//
//  NotificationsContext.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import Foundation
import UserNotifications

@Observable
class NotificationsContext {
    private var notificationCenter = UNUserNotificationCenter.current()
    
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
    // TODO: Implement notification sending
}
