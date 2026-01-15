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
        
        #expect(defaults.integer(forKey: UserDefaults.focusIntervalSeconds) == 25 * 60)
        #expect(defaults.integer(forKey: UserDefaults.breakIntervalSeconds) == 5 * 60)
    }
    
    @Test("init does not override existing values")
    func initDoesNotOverrideExistingValuesForTimeIntervals() async throws {
        defaults.removePersistentDomain(forName: #file)
        defaults.set(50 * 60, forKey: UserDefaults.focusIntervalSeconds)
        defaults.set(10 * 60, forKey: UserDefaults.breakIntervalSeconds)
        
        let _ = TimerContext(userDefaults: defaults)
        
        #expect(defaults.integer(forKey: UserDefaults.focusIntervalSeconds) == 50 * 60)
        #expect(defaults.integer(forKey: UserDefaults.breakIntervalSeconds) == 10 * 60)
    }
    
    @Test("updatePendingTimerFromProvidedMode updates the pending state if still pending")
    func updatePendingTimerFromProvidedModeUpdatesPendingState() async throws {
        defaults.removePersistentDomain(forName: #file)
        let context = TimerContext(userDefaults: defaults)
        try context.updatePendingTimerFromProvidedMode(.breakMode)
        #expect(context.state == .pending(mode: .breakMode))
    }
    
    @Test("updatePendingTimerFromProvidedMode throws correct error if already running")
    func updatePendingTimerFromProvidedModeThrowsCorrectError() async throws {
        defaults.removePersistentDomain(forName: #file)
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        #expect(throws: TimerContext.TimerContextError.timerAlreadyRunning) {
            try context.updatePendingTimerFromProvidedMode(.breakMode)
        }
        #expect(context.state == .running(timeRemaining: 1500.0, mode: .focusMode))
    }
    
    @Test("start correctly decrements the timer after a few seconds")
    func startDecrementsTimer() async throws {
        defaults.removePersistentDomain(forName: #file)
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        try? await Task.sleep(for: .seconds(2.5))
        #expect(context.state == .running(timeRemaining: 1498.0, mode: .focusMode))
    }
    
    @Test("start starts a timer which automatically stops when done")
    func startTimerAutomaticallyStops() async throws {
        defaults.removePersistentDomain(forName: #file)
        
    }
}

@MainActor
struct TimerContextTimerModeTests {
    @Test("getUserDefaultsKey returns correct keys")
    func getUserDefaultsKeyReturnsCorrectKeys() async throws {
        #expect(TimerContext.TimerMode.focusMode.getUserDefaultsKey() == UserDefaults.focusIntervalSeconds)
        #expect(TimerContext.TimerMode.breakMode.getUserDefaultsKey() == UserDefaults.breakIntervalSeconds)
    }
}
