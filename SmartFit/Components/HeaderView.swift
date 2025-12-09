//
//  HeaderView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    @Binding var showingMenu: Bool

    // MARK: - Header con Logo
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Logo App
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.16, green: 0.50, blue: 0.73))
                }
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("SFAthlete")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your Training Partner")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Burger Menu
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingMenu.toggle()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                        
                        VStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                        }
                    }
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.top, 10)
            .padding(.horizontal, 12) // 👈 Riduci da 20 a 12
        }
    }
}
