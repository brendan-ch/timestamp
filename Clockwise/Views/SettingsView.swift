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
    private let appService = SMAppService()
    
    @State private var errorLocalizedDescription: String? = nil

    var body: some View {
        Form {
            Toggle("Open on login", isOn: $launchAtLogin)
            
            if let errorLocalizedDescription = errorLocalizedDescription {
                Text(errorLocalizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .frame(width: 400)
        .onChange(of: launchAtLogin) {
            updateAppServiceRegistration()
        }
        .onAppear {
            initializeOpenOnLoginState()
        }
    }
    
    private func updateAppServiceRegistration() {
        do {
            if launchAtLogin {
                try appService.register()
            } else {
                try appService.unregister()
            }
        } catch {
            errorLocalizedDescription = error.localizedDescription
        }
    }
    
    private func initializeOpenOnLoginState() {
        if appService.status == .enabled {
            launchAtLogin = true
        }
    }
}

#Preview {
    SettingsView()
}
