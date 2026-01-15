//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ContentView: View {
    @State private var timerContext = TimerContext()
    
    var body: some View {
        VStack {
            ClockView()
                .environment(timerContext)
            
            HStack {
                Button {
                    try? timerContext.start()
                } label: {
                    HStack {
                        Text("Start")
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
}
