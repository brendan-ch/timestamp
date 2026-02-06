//
//  UNAuthorizationStatus.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.19.
//

import UserNotifications

extension UNAuthorizationStatus {
    func asString() -> String {
        switch self {
        case .notDetermined:
            "Not determined"
        case .authorized:
            "Granted"
        case .denied:
            "Denied"
        case .provisional:
            "Granted"
        @unknown default:
            "Unknown"
        }
    }
}
