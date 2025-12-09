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
    @StateObject private var workoutApiService = WorkoutApiService()
    @StateObject var vm = CustomerViewModel()

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
                if isLogged || vm.customer != nil {
                    if isLoading {
                        LoadingView()
                    } else if let workoutPlan = currentWorkoutPlan {
                        MainView(workoutPlan: workoutPlan)
                            .environmentObject(vm)
                    } else {
                        ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
                    }
                } else {
                    AuthView()
                        .environmentObject(vm)
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
