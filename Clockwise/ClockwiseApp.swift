//
//  ClockwiseApp.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

@main
struct ClockwiseApp: App {
    @State private var timerContext = TimerContext()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(timerContext)
        } label: {
            HStack {
                Image(systemName: "hourglass")
                Text("Clockwise")
            }
        }
        .menuBarExtraStyle(.window)
    }
}
