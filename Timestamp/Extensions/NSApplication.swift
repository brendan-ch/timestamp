//
//  NSApplication.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.02.13.
//

import AppKit

extension NSApplication {
    func bringToFront(windowTitle: String) {
        bringToFront(windowTitle: windowTitle, remainingAttempts: 20)
    }

    private func bringToFront(windowTitle: String, remainingAttempts: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let window = NSApp.windows.first(where: { $0.title == windowTitle }) {
                NSApp.activate(ignoringOtherApps: true)
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
            } else if remainingAttempts > 0 {
                NSApp.bringToFront(windowTitle: windowTitle, remainingAttempts: remainingAttempts - 1)
            }
        }
    }
}
