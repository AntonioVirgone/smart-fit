//
//  SmartFitApp.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

@main
struct SmartFitApp: App {
    @StateObject private var dataService = WorkoutDataService()
    @StateObject private var historyManager = WorkoutHistoryManager()
        
    init() {
        configureNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(dataService)
                .environmentObject(historyManager)
                .onAppear {
                    print("🚀 GymBro avviato!")
                    print("📱 iOS Version: \(UIDevice.current.systemVersion)")
                }
        }
    }
    
    // MARK: - UI Appearence Setup
    private func configureNavigationBarAppearance() {
        // Personalizzazione globale dell'app (aggiungeremo dopo)
        print("🎨 Configurazione stile della Navigation Bar...")

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
}
