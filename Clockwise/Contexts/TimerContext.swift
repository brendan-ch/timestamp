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
    
    func start() throws {
        if case .pending(let mode) = state {
            do {
                let minutes = userDefaults.integer(forKey: mode.getUserDefaultsKey())
                state = .running(timeRemaining: TimeInterval(minutes * 60), mode: mode)
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
            for await instant in timerSequence {
                if !Task.isCancelled, case .running(let timeRemaining, let mode) = state {
                    state = .running(timeRemaining: timeRemaining - 1, mode: mode)
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
        if case .running(_, let mode) = state {
            state = .pending(mode: mode)
        }
        throw TimerContextError.timerNotRunning
    }
    
    // MARK: Custom data structures
    
    enum State: Equatable {
        case pending(mode: TimerMode)
        case running(timeRemaining: TimeInterval, mode: TimerMode)
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
                return UserDefaults.focusIntervalMinutes
            } else {
                return UserDefaults.breakIntervalMinutes
            }
        }
    }
}
