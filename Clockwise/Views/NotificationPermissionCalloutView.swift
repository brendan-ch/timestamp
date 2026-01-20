//
//  NotificationPermissionTooltipView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.20.
//

import SwiftUI

struct NotificationPermissionCalloutView: View {
    let onDismiss: () -> Void
    
    @Environment(NotificationsContext.self) private var notificationsContext
    @State private var errorLocalizedDescription: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Grant notification permission to receive timer notifications.")
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Button("Grant permission") {
                    grantNotificationPermission()
                    onDismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Dismiss", action: onDismiss)
            }
        }
        .padding()
        .background(in: RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        .backgroundStyle(.thickMaterial)
    }
    
    private func grantNotificationPermission() {
        Task {
            do {
                try await notificationsContext.requestNotificationPermission()
            } catch {
                errorLocalizedDescription = error.localizedDescription
            }
        }
    }
}

#Preview {
    NotificationPermissionCalloutView() { }
        .environment(NotificationsContext())
}
