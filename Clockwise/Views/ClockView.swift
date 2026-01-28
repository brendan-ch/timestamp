//
//  ClockView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ClockView: View {
    @State private var displayedTimeRemaining = "---"
    @State private var circularTrim = 1.0
    @Environment(TimerContext.self) private var timerContext
    
    // From https://stackoverflow.com/questions/77237979/how-to-display-countdown-timer
    var timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: circularTrim)
                    .stroke(
                        Color.blue,
                        lineWidth: 8
                    )
                    .rotationEffect(.degrees(270))
                    .padding(4)
                
                Text(displayedTimeRemaining)
                    .font(.system(size: 64))
                    .bold()
                    .accessibilityLabel("Time remaining")
            }
        }
        .frame(width: 256, height: 256)
        .onChange(of: timerContext.state) {
            update()
        }
        .onAppear {
            update()
        }
    }
    
    private func update() {
        updateRenderedTimer()
        updateCircularTrim()
    }
    
    private func updateRenderedTimer() {
        if case .running(let timeRemaining) = timerContext.state {
            displayedTimeRemaining = timeRemainingFormatter.string(from: timeRemaining) ?? "---"
        } else if case .pending(let mode) = timerContext.state {
            // Note: this will not sync if UserDefaults value changes
            // Recommended to add another change publisher (e.g. through @Environment) when this value changes
            
            let seconds = UserDefaults.standard.integer(forKey: mode.getUserDefaultsKey())
            displayedTimeRemaining = timeRemainingFormatter.string(from: TimeInterval(seconds)) ?? "---"
        }
    }
    
    private func updateCircularTrim() {
        if case .running(let timeRemaining) = timerContext.state {
            if let startingInterval = timerContext.lastTimerStartMetadata?.startingInterval {
                
                let newTrimLevel = timeRemaining / startingInterval
                
                if circularTrim - newTrimLevel > 0.02 {
                    circularTrim = timeRemaining / startingInterval
                } else {
                    withAnimation {
                        circularTrim = timeRemaining / startingInterval
                    }
                }
            }
        } else if case .pending(_) = timerContext.state {
            circularTrim = 1
        }
    }
}

#Preview {
    ClockView()
        .environment(TimerContext())
}
