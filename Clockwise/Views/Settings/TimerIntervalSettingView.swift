//
//  TimerIntervalSettingView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.22.
//

import SwiftUI

struct TimerIntervalSettingView: View {
    @State private var focusIntervalMinutes: String = ""
    @State private var breakIntervalMinutes: String = ""
    
    var body: some View {
        VStack {
            TextField("Focus number of minutes", text: $focusIntervalMinutes)
                .frame(maxWidth: 240)
            TextField("Break number of minutes", text: $breakIntervalMinutes)
                .frame(maxWidth: 240)
        }
    }
}
