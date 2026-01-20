//
//  NotificationPermissionTooltipView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.20.
//

import SwiftUI

struct NotificationPermissionCalloutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Grant notification permission to receive timer notifications.")
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Button("Grant permission") {
                    
                }
                .buttonStyle(.borderedProminent)
                
                Button("Dismiss") {
                    
                }
            }
        }
        .padding()
        .background(in: RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        .backgroundStyle(.thickMaterial)
    }
}

#Preview {
    NotificationPermissionCalloutView()
}
