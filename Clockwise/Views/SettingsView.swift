//
//  SettingsView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import SwiftUI
import ServiceManagement

@MainActor  // for some reason the provided Settings struct throws a warning if this isn't here
struct SettingsView: View {
    @State private var launchAtLogin = false
    let appService = SMAppService()

    var body: some View {
        Form {
            Toggle("Open on login", isOn: $launchAtLogin)
        }
        .padding()
        .frame(width: 400)
        .onChange(of: launchAtLogin) {
            do {
                
                if launchAtLogin {
                    try appService.register()
                } else {
                    try appService.unregister()
                }
            } catch {
                print(error)
            }
        }
        .onAppear {
            if appService.status == .enabled {
                launchAtLogin = true
            }
        }
    }
}

#Preview {
    SettingsView()
}
