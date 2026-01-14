//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ClockView()
            
            HStack {
                Button {
                    
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
