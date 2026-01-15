//
//  ClockView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.14.
//

import SwiftUI

struct ClockView: View {
    var body: some View {
        VStack {
            Text("25:00")
                .font(.system(size: 64))
                .bold()
        }
        .frame(width: 256, height: 256)
    }
}

#Preview {
    ClockView()
}
