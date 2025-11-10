//
//  ContentView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Environment Objects
    @StateObject private var dataService = WorkoutDataService()
    @StateObject private var historyManager = WorkoutHistoryManager()
    
    var body: some View {
        Group {
            if dataService.isLoading {
                LoadingView()
            } else if let workoutPlan = dataService.workoutPlan {
                WorkoutDaysListView(workoutPlan: workoutPlan)
                    .environmentObject(historyManager)
            } else {
                ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
            }
        }
        .onAppear {
            loadInitialData()
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        print("🎯 ContentView - Caricamento dati iniziali")
        dataService.loadWorkoutData()
    }
    
    private func retryLoadingData() {
        print("🔄 ContentView - Riprovo caricamento dati")
        dataService.isLoading = true
        dataService.errorMessage = nil
        loadInitialData()
    }
}
