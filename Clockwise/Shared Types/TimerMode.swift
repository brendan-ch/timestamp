//
//  TimerMode.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.21.
//


import Foundation

enum TimerMode {
    case focusMode
    case breakMode
    
    func getUserDefaultsKey() -> String {
        if self == .focusMode {
            return UserDefaults.focusIntervalSeconds
        } else {
            return UserDefaults.breakIntervalSeconds
        }
    }
    
    func toEndNotification() {
    }
}
