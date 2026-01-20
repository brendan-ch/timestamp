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
    private let userDefaults: UserDefaults
    
    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
        setupUserDefaults()
    }
    
    private func setupUserDefaults() {
        userDefaults.set(false, forKey: UserDefaults.hideGrantNotificationPermissionTooltip)
    }
    
    // MARK: Bridge to UNUserNotificationCenter
    
    func requestNotificationPermission() async throws {
        try await notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        )
    }
    
    func getNotificationPermissionStatus() async -> UNAuthorizationStatus {
        await notificationCenter.notificationSettings().authorizationStatus
    }
    
    // MARK: UI controls
    
    
}
