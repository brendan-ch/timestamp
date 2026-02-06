//
//  TimerMode+Tests.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.21.
//

import Testing
@testable import Timestamp
import Foundation
internal import UserNotifications

@MainActor
struct TimerContextTimerModeTests {
    @Test("getUserDefaultsKey returns correct keys")
    func getUserDefaultsKeyReturnsCorrectKeys() async throws {
        #expect(TimerMode.focusMode.getUserDefaultsKey() == UserDefaults.focusIntervalSeconds)
        #expect(TimerMode.breakMode.getUserDefaultsKey() == UserDefaults.breakIntervalSeconds)
    }
    
    static let modes: [TimerMode] = [.focusMode, .breakMode]
    @Test("constructEndingNotification", arguments: modes)
    func constructEndingNotificationConstructsCorrectBody(mode: TimerMode) async throws {
        let request = mode.constructEndingNotification()
        #expect(request.content.title == "Session ended")
        if mode == .breakMode {
            #expect(request.content.body == "Time to focus.")
        } else {
            #expect(request.content.body == "Time to take a break!")
        }
        #expect(request.content.categoryIdentifier == "timerNotification")
        #expect(request.trigger as? UNTimeIntervalNotificationTrigger != nil)
    }
}
