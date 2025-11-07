//
//  CommonStyle.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

// MARK: - Background
var backgroundGradient: some View {
    LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.11, green: 0.13, blue: 0.19), // Blu notte
            Color(red: 0.16, green: 0.50, blue: 0.73)  // Blu oceano
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    .ignoresSafeArea()
}

