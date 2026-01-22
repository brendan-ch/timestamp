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
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                OpenOnLoginSettingView()
                NotificationPermissionSettingView()
            }
            Spacer()
        }
        .padding()
        .frame(width: 480)
    }
}

#Preview {
    SettingsView()
        .environment(NotificationsContext())
}
