//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(TimerContext.self) private var timerContext
    
    @Environment(\.openSettings) private var openSettings
    
    /// The timer mode selection to show in the UI.
    /// Must be kept in sync manually with the timer context.
    @State private var timerModeSelection: TimerContext.TimerMode = .focusMode
    
    @State private var hideGrantNotificationPermissionCallout = false {
        didSet {
            UserDefaults.standard.set(hideGrantNotificationPermissionCallout, forKey: UserDefaults.hideGrantNotificationPermissionCallout)
        }
    }
    
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
                    Button("Settings", action: openAndShowSettings)
                    Button("Quit", action: quit)
                } label: {
                    Image(systemName: "ellipsis")
                        .accessibilityLabel("Options")
                }
            }
            .frame(minHeight: 32)
            
            if !hideGrantNotificationPermissionCallout {
                NotificationPermissionCalloutView() {
                    hideGrantNotificationPermissionCallout = true
                }
            }
            
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
        .onAppear {
            hideGrantNotificationPermissionCallout = UserDefaults.standard.bool(forKey: UserDefaults.hideGrantNotificationPermissionCallout)
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
    
    private func quit() {
        NSApp.terminate(nil)
    }
    
    private func openAndShowSettings() {
        NSApp.keyWindow?.close()
        NSApplication.shared.activate()
        openSettings()
    }
}

#Preview {
    ContentView()
        .environment(TimerContext())
}
