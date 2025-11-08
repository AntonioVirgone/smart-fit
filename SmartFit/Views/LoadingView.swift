//
//  LoadingView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    
    // MARK: - Properties
    @State private var isRotating = false
    @State private var progress: CGFloat = 0.0
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Sfondo gradient
            backgroundGradient
            
            // Contenuto
            VStack(spacing: 30) {
                // Logo/Icona
                appIcon
                
                // Indicatore di progresso
                progressIndicator
                
                // Testo
                loadingText
            }
            .padding(40)
        }
        .onAppear {
            startAnimations()
        }
    }
        
    // MARK: - App Icon
    private var appIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 120, height: 120)
            
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
        }
    }
    
    // MARK: - Progress Indicator
    private var progressIndicator: some View {
        VStack(spacing: 15) {
            // Barra di progresso
            ZStack(alignment: .leading) {
                // Sfondo barra
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 8)
                
                // Progresso
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: progress * 250, height: 8)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .frame(width: 250)
            
            // Percentuale
            Text("\(Int(progress * 100))%")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Loading Text
    private var loadingText: some View {
        VStack(spacing: 8) {
            Text("GymBro")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Caricamento scheda...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // Animazione rotazione icona
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            isRotating = true
        }
        
        // Animazione progresso
        withAnimation(.easeInOut(duration: 2.0)) {
            progress = 1.0
        }
    }
}
