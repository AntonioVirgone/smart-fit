//
//  CommonStyle.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

// MARK: - Helpers
func headerIconName(muscleGroup: String) -> String {
    switch muscleGroup {
    case "Pettorali": return "figure.strengthtraining.traditional"
    case "Dorsali": return "figure.rower"
    case "Bicipiti": return "figure.arms.open"
    case "Tricipiti": return "figure.arms.open"
    case "Gambe": return "figure.run"
    case "Addominali": return "figure.core.training"
    default: return "dumbbell.fill"
    }
}

func headerIconColor(muscleGroup: String) -> Color {
    switch muscleGroup {
    case "Pettorali": return .blue
    case "Dorsali": return .green
    case "Bicipiti": return .orange
    case "Tricipiti": return .purple
    case "Gambe": return .red
    case "Addominali": return .indigo
    default: return .gray
    }
}


