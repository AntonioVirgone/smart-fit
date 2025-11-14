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
    
    @State private var currentView: AppView = .home // 👈 Stato corrente
    @State private var showingMenu = false
    
    var isLoading: Bool {
        #if targetEnvironment(simulator)
        return apiService.isLoading
        #else
        return dataService.isLoading
        #endif
    }

    var currentWorkoutPlan: WorkoutPlan? {
        #if targetEnvironment(simulator)
        return apiService.workoutPlan
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
                if isLoading {
                    LoadingView()
                } else if let workoutPlan = currentWorkoutPlan {
                    ZStack {
                        VStack(spacing: 16) {
                            // Header con Logo
                            headerView
                            
                            Spacer()
                            
                            // HomeView(workoutPlan: workoutPlan)
                            // View Corrente basata sullo stato
                            switch currentView {
                            case .home:
                                HomeView(workoutPlan: workoutPlan, showingMenu: $showingMenu)
                            case .saveHistory:
                                TestPostApiView()
                            case .getWorkputData:
                                TestApiConnectionView()
                            case .settings:
                                SettingsView()
                            case .history:
                                HistoryView()
                            }
                        }
                        // 👈 MENU OVERLAY A LIVELLO DI ZSTACK - sopra tutto
                        if showingMenu {
                            MenuOverlayView(
                                showingMenu: $showingMenu,
                                currentView: $currentView // 👈 Passa il binding
                            )
                        }
                    }
                } else {
                    ErrorView(message: "Errore caricamento dati", onRetry: retryLoadingData)
                }
            }
        }
        .onAppear {
            loadInitialData()
        }
    }
    
    // MARK: - Header con Logo
    private var headerView: some View {
        VStack(spacing: 16) {
            // Logo App
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.16, green: 0.50, blue: 0.73))
                }
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("GymBro")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your Training Partner")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Burger Menu
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingMenu.toggle()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                        
                        VStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.16, green: 0.50, blue: 0.73))
                                .frame(width: 18, height: 2)
                        }
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
            }
            .padding(.top, 10)
            .padding(.horizontal, 12) // 👈 Riduci da 20 a 12
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
