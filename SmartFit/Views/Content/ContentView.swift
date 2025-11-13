//
//  ContentView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    private let dataOrigin = "REMOTE"
    
    // MARK: - Environment Objects
    @StateObject private var dataService = WorkoutDataService()
    @StateObject private var apiService = APIService()
    
    var body: some View {
        ZStack {
            // 🔹 Sfondo gradiente
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.13, blue: 0.19), // Blu notte
                    Color(red: 0.16, green: 0.50, blue: 0.73)  // Blu oceano
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 🔹 Contenuto principale
            Group {
#if !targetEnvironment(simulator)
                if dataService.isLoading {
                    LoadingView()
                } else if let workoutPlan = dataService.workoutPlan {
                    MainTabView(workoutPlan: workoutPlan)
                } else {
                    ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
                }
#else
                if apiService.isLoading {
                    LoadingView()
                } else if let workoutPlan = apiService.workoutPlan {
                    MainTabView(workoutPlan: workoutPlan)
                } else {
                    ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
                }
#endif
            }
        }
        .onAppear {
            loadInitialData()
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        print("🎯 ContentView - Caricamento dati iniziali")
#if !targetEnvironment(simulator)
        dataService.loadWorkoutData()
#else
        apiService.loadWorkoutData()
#endif
    }
    
    private func retryLoadingData() {
        print("🔄 ContentView - Riprovo caricamento dati")
#if !targetEnvironment(simulator)
        dataService.isLoading = true
        dataService.errorMessage = nil
#else
        apiService.isLoading = true
        apiService.errorMessage = nil
#endif
        loadInitialData()
    }
}
