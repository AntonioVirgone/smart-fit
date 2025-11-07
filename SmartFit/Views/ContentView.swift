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
    
    var body: some View {
        Group {
            if dataService.isLoading {
                LoadingView()
            } else if let workoutPlan = dataService.workoutPlan {
                MainTabView(workoutPlan: workoutPlan)
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

// MARK: - Main Tab View (Placeholder)
struct MainTabView: View {
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        WorkoutDaysListView(workoutPlan: workoutPlan)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
