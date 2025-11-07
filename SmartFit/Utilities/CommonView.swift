//
//  CommonView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 07/11/25.
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

var cardDesign: some View {
    RoundedRectangle(cornerRadius: 12)
        .fill(Color.white.opacity(0.9))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
}
