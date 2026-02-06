//
//  TimerContext+Tests.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.14.
//

import Foundation
import Testing
@testable import Timestamp

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
        
        if case .running(let timeRemaining) = context.state {
            #expect(timeRemaining == 1500.0)
        } else {
            Issue.record("State is not .running")
        }
    }
    
    @Test("start correctly decrements the timer after a few seconds")
    func startDecrementsTimer() async throws {
        defaults.removePersistentDomain(forName: #file)
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        try? await Task.sleep(for: .seconds(2.5))
        
        if case .running(let timeRemaining) = context.state {
            #expect(timeRemaining > 1497.0 && timeRemaining < 1499.0)
        } else {
            Issue.record("State is not .running")
        }
    }
    
    @Test("start throws if timer is already running")
    func startThrowsIfTimerRunning() async throws {
        defaults.removePersistentDomain(forName: #file)
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        #expect(throws: TimerContext.TimerContextError.timerAlreadyRunning) {
            try context.start()
        }
    }
    
    @Test("start starts a timer which automatically sets correct state with next timer mode, when done")
    func startTimerAutomaticallyStops() async throws {
        defaults.removePersistentDomain(forName: #file)
        defaults.set(1, forKey: UserDefaults.focusIntervalSeconds)
        
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        try? await Task.sleep(for: .seconds(3))
        #expect(context.state == .pending(mode: .breakMode))
        #expect(context.lastTimerStopMetadata?.mode == .focusMode)
        #expect(context.lastTimerStopMetadata?.wasBecauseTimerExpired == true)
    }
    
    @Test("start sets correct metadata object for timer start")
    func startTimerSetsCorrectStartMetadataObject() async throws {
        defaults.removePersistentDomain(forName: #file)
        
        let context = TimerContext(userDefaults: defaults)
        let expectedStarter: TimerContext.TimerStartMetadata
        let startingTime = Date.now
        
        if case .pending(let mode) = context.state {
            expectedStarter = .init(mode: mode, start: startingTime, startingInterval: 25 * 60)
        } else {
            Issue.record("context not in pending mode")
            return
        }
        
        try context.start(startingTime: startingTime)
        
        if case .running(_) = context.state {
            #expect(context.lastTimerStartMetadata == expectedStarter)
        } else {
            Issue.record("State is not .running")
        }
    }
    
    static let sleepTimes = [0, 2]
    @Test("stop sets state back to pending, with same mode", arguments: sleepTimes)
    func stopStopsRunningTimer(sleepTime: Int) async throws {
        defaults.removePersistentDomain(forName: #file)
        
        let recordedAt: Date = .now
        
        let context = TimerContext(userDefaults: defaults)
        try context.start()
        try? await Task.sleep(for: .seconds(sleepTime))
        try context.stop(recordedAt: recordedAt)
        try? await Task.sleep(for: .seconds(sleepTime))
        #expect(context.state == .pending(mode: .focusMode))
        #expect(context.lastTimerStopMetadata == .init(
            mode: .focusMode,
            wasBecauseTimerExpired: false,
            recordedAt: recordedAt
        ))
    }
    
    @Test("stop throws if timer is not running")
    func stopThrowsIfNotRunning() async throws {
        defaults.removePersistentDomain(forName: #file)
        
        let context = TimerContext(userDefaults: defaults)
        #expect(throws: TimerContext.TimerContextError.timerNotRunning) {
            try context.stop()
        }
    }
}

