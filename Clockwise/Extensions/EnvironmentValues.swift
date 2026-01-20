//
//  EnvironmentValues.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import SwiftUI
import UserNotifications

// Represents the options available when using the @Environment wrapper

private struct RequestNotificationPermissionKey: EnvironmentKey {
    static let defaultValue: () async throws -> Void = {}
}

private struct GetNotificationPermissionStatusKey: EnvironmentKey {
    static let defaultValue: () async -> UNAuthorizationStatus = { .notDetermined }
}

extension EnvironmentValues {
    var requestNotificationPermission: () async throws -> Void {
        get { self[RequestNotificationPermissionKey.self] }
        set { self[RequestNotificationPermissionKey.self] = newValue }
    }
    
    var getNotificationPermissionStatus: () async -> UNAuthorizationStatus {
        get { self[GetNotificationPermissionStatusKey.self] }
        set { self[GetNotificationPermissionStatusKey.self] = newValue }
    }
}
