//
//  ContentView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonClicked = false
    
    var body: some View {
        VStack {
            ClockView()
            
            HStack {
                Button {
                    buttonClicked = true
                } label: {
                    HStack {
                        Text("Start")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            
            if buttonClicked {
                Text("Button clicked")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
