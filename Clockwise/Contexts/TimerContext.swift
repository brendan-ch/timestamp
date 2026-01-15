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
    
    private(set) var state: State = .pending
    
    private let updateInterval: Duration
    private let userDefaults: UserDefaults
    
    /// Sequence that UI listeners can subscribe to to know when exactly to update the UI.
    var timerUpdateSequence: (any AsyncSequence)? {
        if state == .pending {
            return nil
        }
        
        let clock = ContinuousClock()
        let timerSequence = AsyncTimerSequence(interval: updateInterval, clock: clock)
        let sequence = chain([clock.now].async, timerSequence)
        return sequence
    }
    
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
    
    func start() {
    }
    
    func stop() {
    }
    
    // MARK: Custom data structures
    
    enum State: Equatable {
        case pending
        case running(duration: Duration, start: Date)
    }
}
