//
//  TimerMode.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.21.
//

import Foundation
import UserNotifications

enum TimerMode {
    case focusMode
    case breakMode
}

// MARK: UserDefaults keys for storing time intervals

extension TimerMode {
    func getUserDefaultsKey() -> String {
        if self == .focusMode {
            return UserDefaults.focusIntervalSeconds
        } else {
            return UserDefaults.breakIntervalSeconds
        }
    }
}

// MARK: Ending notification request

extension TimerMode {
    func constructEndingNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Session ended"
        content.categoryIdentifier = "timerNotification"
        if self == .focusMode {
            content.body = "Time to take a break!"
        } else {
            content.body = "Time to focus."
        }
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        return request
    }
}
