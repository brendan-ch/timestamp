//
//  TimerContext.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import Foundation
import AsyncAlgorithms

@Observable
internal class TimerContext {
    private let defaultIntervals = [
        UserDefaults.focusIntervalSeconds: 25 * 60,
        UserDefaults.breakIntervalSeconds: 5 * 60,
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
            let defaultsValue = userDefaults.integer(forKey: key)
            if defaultsValue == 0 {
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
    
    func start() throws {
        if case .pending(let mode) = state {
            do {
                let seconds = userDefaults.integer(forKey: mode.getUserDefaultsKey())
                state = .running(timeRemaining: TimeInterval(seconds), starter: .init(mode: .focusMode, start: .now, startingInterval: TimeInterval(seconds)))
                try setTimerUpdateTask()
            } catch {
                state = .pending(mode: mode)
                throw error
            }
        } else {
            throw TimerContextError.timerAlreadyRunning
        }
    }
    
    private func setTimerUpdateTask() throws {
        let timerSequence = try getTimerSequence()
        
        timerUpdateTask = Task {
            for await _ in timerSequence {
                if !Task.isCancelled, case .running(_, let starter) = state {
                    if starter.derivedTimeRemaining < 0 {
                        try stop()
                    }
                    
                    state = .running(
                        timeRemaining: starter.derivedTimeRemaining,
                        starter: starter
                    )
                } else {
                    break
                }
            }
        }
    }
    
    private func getTimerSequence() throws -> AsyncTimerSequence<ContinuousClock> {
        if case .running(_, _) = state {
            let clock = ContinuousClock()
            let timerSequence = AsyncTimerSequence(interval: updateInterval, tolerance: .nanoseconds(1), clock: clock)
            
            return timerSequence
        }
        
        throw TimerContextError.timerNotRunning
    }

    func stop() throws {
        if case .running(_, let starter) = state {
            state = .pending(mode: starter.mode)
        } else {
            throw TimerContextError.timerNotRunning
        }
    }
    
    // MARK: Custom data structures
    
    enum State: Equatable {
        case pending(mode: TimerMode)
        case running(timeRemaining: TimeInterval, starter: StarterInfo)
        
        struct StarterInfo: Equatable {
            let mode: TimerMode
            let start: Date
            let startingInterval: TimeInterval
            
            var derivedTimeRemaining: TimeInterval {
                startingInterval - (Date.now.timeIntervalSince(start))
            }
        }
    }
    
    enum TimerContextError: Error {
        case timerAlreadyRunning
        case timerNotRunning
    }
    
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
    }
}
