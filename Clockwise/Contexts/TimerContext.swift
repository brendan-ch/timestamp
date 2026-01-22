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
    
    /// Stores information about the last timer start.
    /// Does not get cleared on timer stop or expiration.
    private(set) var lastTimerStartMetadata: TimerStartMetadata? = nil
    
    /// Stores information about the last time the timer was stopped.
    /// Does not get cleared on timer start.
    private(set) var lastTimerStopMetadata: TimerStopMetadata? = nil
    
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
    
    func start(startingTime: Date = .now) throws {
        if case .pending(let mode) = state {
            do {
                let seconds = userDefaults.integer(forKey: mode.getUserDefaultsKey())
                state = .running(timeRemaining: TimeInterval(seconds))
                
                let timerStartMetadata: TimerStartMetadata = .init(mode: mode, start: startingTime, startingInterval: TimeInterval(seconds))
                try setTimerUpdateTask(metadata: timerStartMetadata)
                
                // Publish as the last step
                lastTimerStartMetadata = timerStartMetadata
            } catch {
                state = .pending(mode: mode)
                throw error
            }
        } else {
            throw TimerContextError.timerAlreadyRunning
        }
    }
    
    private func setTimerUpdateTask(metadata: TimerStartMetadata) throws {
        let timerSequence = try getTimerSequence()
        
        timerUpdateTask = Task {
            for await _ in timerSequence {
                if !Task.isCancelled, case .running(_) = state {
                    if metadata.derivedTimeRemaining < 0 {
                        try stop()
                        break
                    }
                    
                    state = .running(
                        timeRemaining: metadata.derivedTimeRemaining,
                    )
                } else {
                    break
                }
            }
        }
    }
    
    private func getTimerSequence() throws -> AsyncTimerSequence<ContinuousClock> {
        if case .running(_) = state {
            let clock = ContinuousClock()
            let timerSequence = AsyncTimerSequence(interval: updateInterval, tolerance: .nanoseconds(1), clock: clock)
            
            return timerSequence
        }
        
        throw TimerContextError.timerNotRunning
    }

    /// Stops the timer, setting the state back to `State.pending`.
    /// If the timer has expired, this method sets the timer mode to the next mode. Otherwise, the method sets the same timer mode.
    func stop() throws {
        if case .running(_) = state {
            let currentTimerMode: TimerMode
            if let lastTimerStartMetadata {
                currentTimerMode = lastTimerStartMetadata.mode
            } else {
                currentTimerMode = .focusMode
            }
            
            let wasBecauseTimerExpired = lastTimerStartMetadata?.timerExpired ?? false
            
            state = .pending(mode: wasBecauseTimerExpired ? currentTimerMode.next() : currentTimerMode)
            lastTimerStopMetadata = .init(mode: currentTimerMode, wasBecauseTimerExpired: wasBecauseTimerExpired)
        } else {
            throw TimerContextError.timerNotRunning
        }
    }
    
    // MARK: Custom data structures
    
    enum State: Equatable {
        case pending(mode: TimerMode)
        case running(timeRemaining: TimeInterval)
    }
    
    /// Metadata about a timer start.
    struct TimerStartMetadata: Equatable {
        let mode: TimerMode
        let start: Date
        let startingInterval: TimeInterval
        let recordedAt: Date = .now

        var derivedTimeRemaining: TimeInterval {
            startingInterval - (Date.now.timeIntervalSince(start))
        }
        
        var timerExpired: Bool {
            derivedTimeRemaining <= 0
        }
    }
    
    struct TimerStopMetadata: Equatable {
        /// The mode that the stopped timer was in.
        let mode: TimerMode
        let wasBecauseTimerExpired: Bool
        let recordedAt: Date = .now
    }

    enum TimerContextError: Error {
        case timerAlreadyRunning
        case timerNotRunning
    }
}
