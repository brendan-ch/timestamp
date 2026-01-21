//
//  NotificationsContextView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.20.
//

import SwiftUI

protocol NotificationsContextView: ErrorHandlingView {
    var notificationsContext: NotificationsContext { get }
    
    func grantNotificationPermission() -> Void
}

extension NotificationsContextView {
    func grantNotificationPermission() {
        Task {
            do {
                try await notificationsContext.requestNotificationPermission()
            } catch {
                handleError(error)
            }
        }
    }
}
