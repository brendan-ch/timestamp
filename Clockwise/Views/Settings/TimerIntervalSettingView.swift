//
//  TimerIntervalSettingView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.22.
//

import SwiftUI

struct TimerIntervalSettingView: View {
    @State private var focusIntervalMinutes: Int = 0
    @State private var breakIntervalMinutes: Int = 0
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            TextField("Focus number of minutes", value: $focusIntervalMinutes, formatter: formatter)
                .frame(maxWidth: 240)
            TextField("Break number of minutes", value: $breakIntervalMinutes, formatter: formatter)
                .frame(maxWidth: 240)
        }
        .onAppear {
            initializeTextFields()
        }
        .onChange(of: focusIntervalMinutes) {
            updateDefaults(minutes: focusIntervalMinutes, forKey: UserDefaults.focusIntervalSeconds)
        }
        .onChange(of: breakIntervalMinutes) {
            updateDefaults(minutes: breakIntervalMinutes, forKey: UserDefaults.breakIntervalSeconds)
        }
    }
    
    private func initializeTextFields() {
        focusIntervalMinutes = UserDefaults.standard.integer(forKey: UserDefaults.focusIntervalSeconds) / 60
        breakIntervalMinutes = UserDefaults.standard.integer(forKey: UserDefaults.breakIntervalSeconds) / 60
    }
    
    private func updateDefaults(minutes: Int, forKey key: String) {
        UserDefaults.standard.set(minutes * 60, forKey: key)
    }
}
