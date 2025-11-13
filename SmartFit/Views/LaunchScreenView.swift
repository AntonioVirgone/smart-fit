//
//  SplashView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            // Qui va la tua vista principale
            ContentView()
        } else {
            ZStack {
                // Sfondo (puoi personalizzare)
                backgroundGradient
                
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
                    
                    // Sottotitolo opzionale
                    Text("Your Fitness Companion")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 5)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // Tempo di visualizzazione della launch screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
