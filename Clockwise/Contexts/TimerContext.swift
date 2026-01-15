//
//  TimerContext.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import Foundation
import AsyncAlgorithms

@Observable
class TimerContext {
    private let defaultIntervals = [
        UserDefaults.focusIntervalMinutes: 25,
        UserDefaults.breakIntervalMinutes: 5,
    ]
    
    private(set) var state: State = .pending(mode: .focusMode)
    
    private let updateInterval: Duration
    private let userDefaults: UserDefaults
    private var timerUpdateTask: Task<Void, Error>? = nil
    
    init(
        updateInterval: Duration = .seconds(1),
        userDefaults: UserDefaults = .standard
    ) {
        self.updateInterval = updateInterval
        self.userDefaults = userDefaults
        
        setupUserDefaults()
    }
    
    private func setupUserDefaults() {
        for (key, value) in defaultIntervals {
            let minutes = userDefaults.integer(forKey: key)
            if minutes == 0 {
                userDefaults.set(value, forKey: key)
            }
        }
    }
    
    func updatePendingTimerFromProvidedMode(_ mode: TimerMode) throws {
        if case .pending(_) = state {
            state = .pending(mode: mode)
        } else {
            throw TimerContextError.timerAlreadyRunning
        }
    }
    
    func start() {
        
    }
    
    private func getTimerSequence() -> AsyncTimerSequence<ContinuousClock>? {
        if case .running(_) = state {
            let clock = ContinuousClock()
            let timerSequence = AsyncTimerSequence(interval: updateInterval, tolerance: .nanoseconds(1), clock: clock)
            
            return timerSequence
        }
        
        return nil
    }

    func stop() {
        
    }
    
    // MARK: Custom data structures
    
    enum State: Equatable {
        case pending(mode: TimerMode)
        case running(timeRemaining: TimeInterval)
    }
    
    enum TimerContextError: Error {
        case timerAlreadyRunning
    }
    
    enum TimerMode {
        case focusMode
        case breakMode
    }
}
