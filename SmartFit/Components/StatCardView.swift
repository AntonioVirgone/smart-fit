//
//  StatCard.swift
//  SFAthlete
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI

struct StatCardView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
