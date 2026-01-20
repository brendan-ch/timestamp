//
//  ClockwiseApp.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI
import UserNotifications

@main
struct ClockwiseApp: App {
    @State private var timerContext = TimerContext()
    @State private var menuBarText: String? = nil
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(timerContext)
                .environment(\.requestNotificationPermission, requestNotificationPermission)
                .environment(\.getNotificationPermissionStatus, getNotificationPermissionStatus)
        } label: {
            HStack {
                Image(systemName: "hourglass")
                if let menuBarText = menuBarText {
                    Text(menuBarText)
                }
            }
        }
        .menuBarExtraStyle(.window)
        .onChange(of: timerContext.state) {
            updateMenuBarText()
        }
        
        Settings(content: SettingsView.init)
            .environment(\.requestNotificationPermission, requestNotificationPermission)
            .environment(\.getNotificationPermissionStatus, getNotificationPermissionStatus)
    }
    
    private func updateMenuBarText() {
        if case .running(let timeRemaining, _) = timerContext.state {
            let minutesToDisplay = Int(timeRemaining / 60)
            if minutesToDisplay == 0 {
                menuBarText = "<1m"
            } else {
                menuBarText = "\(minutesToDisplay)m"
            }
        } else {
            menuBarText = nil
        }
    }
    
    private func requestNotificationPermission() async throws {
        try await notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        )
    }
    
    private func getNotificationPermissionStatus() async -> UNAuthorizationStatus {
        await notificationCenter.notificationSettings().authorizationStatus
    }
}
