//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ContentView: View {
    @Environment(TimerContext.self) private var timerContext
    
    /// The timer mode selection to show in the UI.
    /// Must be kept in sync manually with the timer context.
    @State private var timerModeSelection: TimerContext.TimerMode = .focusMode
    
    private var isRunning: Bool {
        switch timerContext.state {
        case .pending(_):
            return false
        case .running(_, _):
            return true
        }

    }
    private var buttonText: String {
        isRunning ? "Stop" : "Start"
    }
    
    var body: some View {
        VStack {
            HStack {
                if !isRunning {
                    Picker("Timer mode", selection: $timerModeSelection) {
                        Text("Focus").tag(TimerContext.TimerMode.focusMode)
                        Text("Break").tag(TimerContext.TimerMode.breakMode)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
                Spacer()
                
                Menu {
                    SettingsLink {
                        Text("Settings")
                    }
                    Button("Quit", action: quit)
                } label: {
                    Image(systemName: "ellipsis")
                        .accessibilityLabel("Options")
                }
            }
            .frame(minHeight: 32)
            
            ClockView()
                .environment(timerContext)
            
            HStack {
                Button {
                    if isRunning {
                        try? timerContext.stop()
                    } else {
                        try? timerContext.start()
                    }
                } label: {
                    HStack {
                        Text(buttonText)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .onChange(of: timerModeSelection) {
            try? timerContext.updatePendingTimerFromProvidedMode(timerModeSelection)
        }
        .onChange(of: timerContext.state) {
            if case .pending(let mode) = timerContext.state {
                timerModeSelection = mode
            }
        }
        .padding()
        .frame(width: 320)
    }
    
    func quit() {
        NSApp.terminate(nil)
    }
}

#Preview {
    ContentView()
        .environment(TimerContext())
}
