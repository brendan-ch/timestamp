//
//  ContentView.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var fitsWindowToContent = false
    
    @Environment(TimerContext.self) private var timerContext
    
    @Environment(\.openWindow) private var openWindow
    
    /// The timer mode selection to show in the UI.
    /// Must be kept in sync manually with the timer context.
    @State private var timerModeSelection: TimerMode = .focusMode
    
    @State private var hideGrantNotificationPermissionCallout = UserDefaults.standard.bool(forKey: UserDefaults.hideGrantNotificationPermissionCallout) {
        didSet {
            UserDefaults.standard.set(hideGrantNotificationPermissionCallout, forKey: UserDefaults.hideGrantNotificationPermissionCallout)
        }
    }
    
    @State private var calloutHeight: CGFloat = 0
    @State private var hostWindow: NSWindow? = nil
    
    private var isRunning: Bool {
        switch timerContext.state {
        case .pending(_):
            return false
        case .running(_):
            return true
        }

    }
    private var buttonText: String {
        isRunning ? "Stop" : "Start"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                if !isRunning {
                    Picker("Timer mode", selection: $timerModeSelection) {
                        Text("Focus").tag(TimerMode.focusMode)
                        Text("Break").tag(TimerMode.breakMode)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    
                    Button {
                        timerModeSelection = timerModeSelection.next()
                    } label: {
                        EmptyView()
                    }
                    .hidden()
                    .keyboardShortcut("`", modifiers: [])
                }
                Spacer()
                
                Button {
                    openSettingsWindow()
                } label: {
                    EmptyView()
                }
                .hidden()
                .keyboardShortcut(",", modifiers: .command)
                
                Menu {
                    Button("Settings") {
                        openSettingsWindow()
                    }
                    Button("Quit", action: quit)
                } label: {
                    Image(systemName: "ellipsis")
                        .accessibilityLabel("Options")
                }
            }
            .frame(minHeight: 32)
            
            if !hideGrantNotificationPermissionCallout {
                NotificationPermissionCalloutView(onDismiss: dismissCallout)
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.height
                    } action: { height in
                        calloutHeight = height
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
                .keyboardShortcut(.space, modifiers: [])
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
        .background {
            HostWindowReader { window in
                hostWindow = window
            }
        }
    }
    
    private func dismissCallout() {
        hideGrantNotificationPermissionCallout = true
        shrinkWindowToContent()
    }
    
    private func shrinkWindowToContent() {
        guard fitsWindowToContent, let window = hostWindow, calloutHeight > 0 else { return }
        var frame = window.frame
        frame.origin.y += calloutHeight
        frame.size.height -= calloutHeight
        window.setFrame(frame, display: true)
        calloutHeight = 0
    }
    
    private func openSettingsWindow() {
        openWindow(id: "settings")
        NSApp.bringToFront(windowTitle: "Timestamp Settings")
    }
    
    private func quit() {
        NSApp.terminate(nil)
    }
}

private struct HostWindowReader: NSViewRepresentable {
    final class HostView: NSView {
        var onWindow: ((NSWindow?) -> Void)?
        
        override func viewDidMoveToWindow() {
            DispatchQueue.main.async {
                self.onWindow?(self.window)
            }
        }
    }
    
    let onWindow: (NSWindow?) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = HostView()
        view.onWindow = onWindow
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

#Preview {
    ContentView()
        .environment(TimerContext())
        .environment(NotificationsContext())
}
