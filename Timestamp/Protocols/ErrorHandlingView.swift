//
//  ErrorLocalizedDescriptionView.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.20.
//

import SwiftUI

protocol ErrorHandlingView: View {
    func handleError(_ error: any Error) -> Void
}
