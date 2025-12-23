//
//  CommonView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 07/11/25.
//

import Foundation
import SwiftUI

private var size = 0.8
private var opacity = 0.5

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

var logo: some View {
    VStack {
        // Logo o icona dell'app
        Image(systemName: "dumbbell.fill")
            .font(.system(size: 80))
            .foregroundColor(.white)
        
        // Nome dell'app
        Text("SmartFit")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    .scaleEffect(size)
    .opacity(opacity)
    /*
     .onAppear {
     withAnimation(.easeIn(duration: 1.2)) {
     self.size = 1.0
     self.opacity = 1.0
     }
     }
     */
}

func separator(circleColor: Color = .gray, isLoading: Bool = false) -> some View {
    HStack {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)

        if isLoading {
            ProgressView("")
                .tint(circleColor)
        } else {
            Circle()
                .frame(width: 14, height: 14)
                .foregroundColor(circleColor)
        }
        
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)
    }
    .padding(.horizontal, 20)
}
