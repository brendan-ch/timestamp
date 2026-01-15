//
//  TimerContext+Tests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import Foundation
import Testing
@testable import Clockwise

@MainActor
struct TimerContextTests {
    var defaults: UserDefaults {
        UserDefaults(suiteName: #file)!
    }
    
    @Test("init performs UserDefaults setup with default values")
    func initSetsUpDefaultValuesForTimeIntervals() async throws {
        defaults.removePersistentDomain(forName: #file)
        let _ = TimerContext(userDefaults: defaults)
        
        #expect(defaults.integer(forKey: UserDefaults.focusIntervalMinutes) == 25)
        #expect(defaults.integer(forKey: UserDefaults.breakIntervalMinutes) == 5)
    }
    
    @Test("init does not override existing values")
    func initDoesNotOverrideExistingValuesForTimeIntervals() async throws {
        defaults.removePersistentDomain(forName: #file)
        defaults.set(50, forKey: UserDefaults.focusIntervalMinutes)
        defaults.set(10, forKey: UserDefaults.breakIntervalMinutes)
        
        let _ = TimerContext(userDefaults: defaults)
        
        #expect(defaults.integer(forKey: UserDefaults.focusIntervalMinutes) == 50)
        #expect(defaults.integer(forKey: UserDefaults.breakIntervalMinutes) == 10)
    }
    
    @Test("updatePendingTimerFromProvidedMode updates the pending state if still pending")
    func updatePendingTimerFromProvidedModeUpdatesPendingState() async throws {
        let context = TimerContext(userDefaults: defaults)
        try context.updatePendingTimerFromProvidedMode(.breakMode)
        #expect(context.state == .pending(mode: .breakMode))
    }
    
    @Test("updatePendingTimerFromProvidedMode throws correct error if already running")
    func updatePendingTimerFromProvidedModeThrowsCorrectError() async throws {
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        #expect(throws: TimerContext.TimerContextError.timerAlreadyRunning) {
            try context.updatePendingTimerFromProvidedMode(.breakMode)
        }
        #expect(context.state == .running(timeRemaining: 1500.0, mode: .focusMode))
    }
}

@MainActor
struct TimerContextTimerModeTests {
    @Test("getUserDefaultsKey returns correct keys")
    func getUserDefaultsKeyReturnsCorrectKeys() async throws {
        #expect(TimerContext.TimerMode.focusMode.getUserDefaultsKey() == UserDefaults.focusIntervalMinutes)
        #expect(TimerContext.TimerMode.breakMode.getUserDefaultsKey() == UserDefaults.breakIntervalMinutes)
    }
}
