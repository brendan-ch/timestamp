//
//  NSApplication.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.02.13.
//

import AppKit

extension NSApplication {
    func bringToFront() {
        DispatchQueue.main.async {
            self.activate(ignoringOtherApps: true)
        }
    }
}
