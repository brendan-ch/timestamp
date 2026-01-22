//
//  OpenOnLoginSettingView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.22.
//

import SwiftUI
import ServiceManagement

struct OpenOnLoginSettingView: ErrorHandlingView {
    @State private var launchAtLogin = false
    private let appService = SMAppService()
    
    @State private var errorLocalizedDescription: String? = nil
    
    var body: some View {
        VStack {
            Toggle("Open on login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) {
                    updateAppServiceRegistration()
                }
                .onAppear {
                    initializeOpenOnLoginState()
                }
            
            if let errorLocalizedDescription = errorLocalizedDescription {
                Text(errorLocalizedDescription)
                    .foregroundStyle(.red)
            }
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
            handleError(error)
        }
    }
    
    private func initializeOpenOnLoginState() {
        if appService.status == .enabled {
            launchAtLogin = true
        }
    }
    
    func handleError(_ error: any Error) {
        errorLocalizedDescription = error.localizedDescription
    }
}
