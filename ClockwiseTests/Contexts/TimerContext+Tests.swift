//
//  TimerContext.swift
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
}
