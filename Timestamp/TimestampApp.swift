//
//  TimestampApp.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI
import UserNotifications

@main
struct TimestampApp: App {
    @State private var timerContext = TimerContext()
    @State private var notificationsContext = NotificationsContext()
    @State private var menuBarText: String? = nil
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(timerContext)
                .environment(notificationsContext)
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
        .onChange(of: timerContext.lastTimerStopMetadata) {
            scheduleNotificationIfTimerHasEnded()
        }
        
        Settings(content: SettingsView.init)
            .environment(notificationsContext)
    }
    
    private func updateMenuBarText() {
        if case .running(let timeRemaining) = timerContext.state {
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
    
    private func scheduleNotificationIfTimerHasEnded() {
        if let lastTimerStopMetadata = timerContext.lastTimerStopMetadata {
            if lastTimerStopMetadata.wasBecauseTimerExpired {
                let request = lastTimerStopMetadata.mode.constructEndingNotification()
                notificationsContext.scheduleIfHasPermission(request)
            }
        }
    }
}
