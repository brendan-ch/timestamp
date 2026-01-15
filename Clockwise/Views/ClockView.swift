//
//  ClockView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ClockView: View {
    @State private var displayedTimeRemaining = "---"
    @Environment(TimerContext.self) private var timerContext
    
    // From https://stackoverflow.com/questions/77237979/how-to-display-countdown-timer
    var timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(displayedTimeRemaining)
                .font(.system(size: 64))
                .bold()
        }
        .frame(width: 256, height: 256)
        .onChange(of: timerContext.state) {
            updateDisplayedTimeRemaining()
        }
        .onAppear {
            updateDisplayedTimeRemaining()
        }
    }
    
    private func updateDisplayedTimeRemaining() {
        if case .running(let timeRemaining, _) = timerContext.state {
            displayedTimeRemaining = timeRemainingFormatter.string(from: timeRemaining) ?? "---"
        } else if case .pending(let mode) = timerContext.state {
            // Note: this will not sync if UserDefaults value changes
            // Recommended to add another change publisher (e.g. through @Environment) when this value changes
            
            let seconds = UserDefaults.standard.integer(forKey: mode.getUserDefaultsKey())
            displayedTimeRemaining = timeRemainingFormatter.string(from: TimeInterval(seconds)) ?? "---"
        }
    }
}

#Preview {
    ClockView()
        .environment(TimerContext())
}
