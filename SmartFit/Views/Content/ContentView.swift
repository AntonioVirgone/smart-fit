//
//  ContentView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Environment Objects
    @EnvironmentObject private var dataService: WorkoutDataService
    @EnvironmentObject private var historyManager: WorkoutHistoryManager

    // MARK: - Local State Objects
    @StateObject private var workoutApiService = WorkoutApiService()
    @StateObject private var viewModel = CustomerViewModel()

    var isLogged: Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn");
    }
    
    var isLoading: Bool {
#if targetEnvironment(simulator)
        return workoutApiService.isLoading
#else
        return dataService.isLoading
#endif
    }
    
    var currentWorkoutPlan: WorkoutPlan? {
#if targetEnvironment(simulator)
        return workoutApiService.workoutPlan
#else
        return dataService.workoutPlan
#endif
    }
    
    var body: some View {
        ZStack {
            // 🔹 Sfondo gradiente
            backgroundGradient
            
            // 🔹 Contenuto principale
            Group {
                if isLogged || viewModel.customer != nil {
                    if isLoading {
                        LoadingView()
                    } else if let workoutPlan = currentWorkoutPlan {
                        MainView(workoutPlan: workoutPlan)
                            .environmentObject(viewModel)
                            .environmentObject(historyManager)
                    } else {
                        ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
                    }
                } else {
                    AuthView()
                        .environmentObject(viewModel)
                }
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
        workoutApiService.loadWorkoutData()
#endif
    }
    
    private func retryLoadingData() {
        print("🔄 ContentView - Riprovo caricamento dati")
#if !targetEnvironment(simulator)
        dataService.isLoading = true
        dataService.errorMessage = nil
#else
        workoutApiService.isLoading = true
        workoutApiService.errorMessage = nil
#endif
        loadInitialData()
    }
}
