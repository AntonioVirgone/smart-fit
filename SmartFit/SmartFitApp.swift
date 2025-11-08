//
//  SmartFitApp.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

@main
struct SmartFitApp: App {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // ✅ rende la barra trasparente
        
        // Titolo bianco
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Applica a TUTTE le possibili varianti
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Colore pulsanti (es: freccia "indietro")
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(WorkoutHistoryManager())
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
