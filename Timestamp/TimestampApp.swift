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
            .background {
                MainWindowLifecycleObserver()
                    .environment(notificationsContext)
            }
        }
        .menuBarExtraStyle(.window)
        .onChange(of: timerContext.state) {
            updateMenuBarText()
        }
        .onChange(of: timerContext.lastTimerStopMetadata) {
            scheduleNotificationIfTimerHasEnded()
        }
        
        Window("Timestamp", id: "main") {
            ContentView(fitsWindowToContent: true)
                .environment(timerContext)
                .environment(notificationsContext)
                .fixedSize(horizontal: false, vertical: true)
        }
        .defaultLaunchBehavior(.suppressed)
        .restorationBehavior(.disabled)
        .windowResizability(.contentSize)
        
        Window("Timestamp Settings", id: "settings") {
            SettingsView()
                .environment(notificationsContext)
        }
        .defaultLaunchBehavior(.suppressed)
        .restorationBehavior(.disabled)
        .windowResizability(.contentSize)
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

private struct MainWindowLifecycleObserver: View {
    @Environment(NotificationsContext.self) private var notificationsContext
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Color.clear
            .onAppear {
                if UserDefaults.standard.bool(forKey: "openMainWindow") {
                    openMainWindow()
                }
            }
            .onChange(of: notificationsContext.notificationClickCount) {
                openMainWindow()
            }
    }
    
    private func openMainWindow() {
        openWindow(id: "main")
        NSApp.bringToFront(windowTitle: "Timestamp")
    }
}
