//
//  NotificationPermissionSettingView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.22.
//

import SwiftUI
import UserNotifications

struct NotificationPermissionSettingView: NotificationsContextView {
    @Environment(NotificationsContext.self) var notificationsContext
    @State private var renderedNotificationPermissionStatus: UNAuthorizationStatus = .notDetermined
    
    @State private var errorLocalizedDescription: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text("Notification permission: \(renderedNotificationPermissionStatus.asString())")
            
            if renderedNotificationPermissionStatus == .notDetermined {
                Button("Grant notification permission", action: grantNotificationPermission)
                    .buttonStyle(.borderedProminent)
            }
            Button("Open system notification settings", action: openNotificationSystemSettingsPane)
            
            Text(
                "Receive notifications when a timer ends."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            
            if let errorLocalizedDescription = errorLocalizedDescription {
                Text(errorLocalizedDescription)
                    .foregroundStyle(.red)
            }
        }
    }
    
    private func initializeNotificationPermissionState() {
        Task {
            renderedNotificationPermissionStatus = await notificationsContext.getNotificationPermissionStatus()
        }
    }
    
    private func openNotificationSystemSettingsPane() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func handleError(_ error: any Error) {
        errorLocalizedDescription = error.localizedDescription
    }
}
