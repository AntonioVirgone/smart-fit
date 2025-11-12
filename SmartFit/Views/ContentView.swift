//
//  ContentView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Environment Objects
//    @StateObject private var dataService = WorkoutDataService()
    @StateObject private var apiService = APIService()
    @StateObject private var historyManager = WorkoutHistoryManager()
    
    var body: some View {
        Group {
            if apiService.isLoading {
                LoadingView()
            } else if let workoutPlan = apiService.workoutPlan {
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
        apiService.loadWorkoutData()
    }
    
    private func retryLoadingData() {
        print("🔄 ContentView - Riprovo caricamento dati")
        apiService.isLoading = true
        apiService.errorMessage = nil
        loadInitialData()
    }
}

// Sostituisci il placeholder MainTabView con questa versione completa:
struct MainTabView: View {
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        TabView {
            // Tab Allenamento
            WorkoutDaysListView(workoutPlan: workoutPlan)
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Allenamento")
                }
            
            // Tab Progressi
            TestApiConnectionView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progressi")
                }
            
            TestPostApiView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Save History")
                }
            
            // Tab Impostazioni
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Impostazioni")
                }
        }
    }
}

// Placeholder per ProgressOverviewView (lo svilupperemo nella prossima fase)
struct ProgressOverviewView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Panoramica Progressi")
                    .font(.title2)
                    .padding()
                
                Text("Qui vedrai i tuoi progressi complessivi")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Progressi")
        }
    }
}
