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
        
        Settings(content: SettingsView.init)
            .environment(notificationsContext)
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
}
