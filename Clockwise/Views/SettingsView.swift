//
//  SettingsView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import SwiftUI
import ServiceManagement
import UserNotifications

@MainActor  // for some reason the provided Settings struct throws a warning if this isn't here
struct SettingsView: View {
    @State private var launchAtLogin = false
    private let appService = SMAppService()
    
    @State private var errorLocalizedDescription: String? = nil
    
    @Environment(\.requestNotificationPermission) private var requestNotificationPermission
    @Environment(\.getNotificationPermissionStatus) private var getNotificationPermissionStatus
    @State private var renderedNotificationPermissionStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Open on login", isOn: $launchAtLogin)
                
                VStack(alignment: .leading) {
                    Text("Notification permission: not granted")
                    
                    if renderedNotificationPermissionStatus == .notDetermined {
                        Button("Grant notification permission", action: grantNotificationPermission)
                            .buttonStyle(.borderedProminent)
                    }
                    Button("Open system notification settings", action: openNotificationSystemSettingsPane)
                    Text(
                    """
                    Grant permission to send timer notifications.
                    """
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                }

                if let errorLocalizedDescription = errorLocalizedDescription {
                    Text(errorLocalizedDescription)
                        .foregroundStyle(.red)
                }
                
            }
            Spacer()
        }
        .padding()
        .frame(width: 480)
        .onChange(of: launchAtLogin) {
            updateAppServiceRegistration()
        }
        .onAppear(perform: initializeAllStates)
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
    
    private func initializeAllStates() {
        initializeOpenOnLoginState()
        initializeNotificationPermissionState()
    }
    
    private func initializeOpenOnLoginState() {
        if appService.status == .enabled {
            launchAtLogin = true
        }
    }
    
    private func initializeNotificationPermissionState() {
        Task {
            renderedNotificationPermissionStatus = await getNotificationPermissionStatus()
        }
    }

    private func grantNotificationPermission() {
        Task {
            do {
                try await requestNotificationPermission()
            } catch {
                errorLocalizedDescription = error.localizedDescription
            }
        }
    }
    
    private func openNotificationSystemSettingsPane() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.requestNotificationPermission) {
            print("Requesting notification permission")
        }
}
