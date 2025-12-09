//
//  DiscoverCard.swift
//  SFAthlete
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI

struct DiscoverCardView: View {
    let title: String
    let exercises: Int
    let minutes: Int
    let color: Color
    let isAnimated: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("\(exercises) Exercises\n\(minutes) Minutes")
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
            .frame(width: 200, height: 120)
            .background(color)
            .cornerRadius(16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
