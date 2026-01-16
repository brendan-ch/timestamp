//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ContentView: View {
    @Environment(TimerContext.self) private var timerContext
    
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
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(TimerContext())
}
