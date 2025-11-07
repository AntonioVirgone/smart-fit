//
//  SmartFitApp.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

@main
struct SmartFitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("🚀 SmartFit avviato!")
                    setupAppearance()
                }
        }
    }
    
    // MARK: - UI Setup
    private func setupAppearance() {
        // Personalizzazione globale dell'app (aggiungeremo dopo)
        print("🎨 Configurazione aspetto app...")
    }
}
