//
//  NewHomeView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

struct NewHomeView: View {
    let workoutPlan: WorkoutPlan
    @State private var selectedDay: WorkoutDay?
    @State private var animationStates: [UUID: Bool] = [:]
    
    // Gradienti per ogni tipo di giornata
    let dayGradients: [LinearGradient] = [
        // Giornata 1 - Petto/Tricipiti
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.20, green: 0.60, blue: 0.86), Color(red: 0.16, green: 0.50, blue: 0.73)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        // Giornata 2 - Dorsali/Bicipiti
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.20, green: 0.80, blue: 0.35), Color(red: 0.00, green: 0.50, blue: 0.25)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        // Giornata 3 - Gambe/Spalle
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.80, green: 0.30, blue: 0.10), Color(red: 0.60, green: 0.20, blue: 0.00)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ]
    
    var body: some View {
        ZStack {
            // Sfondo gradient mantenendo lo stile originale
            backgroundGradient
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header con Logo
                    headerView
                    
                    Spacer()
                    
                    // Statistiche Overview
                    statsOverviewView

                    Spacer()
                    
                    // Cerchi Giornate Allenamento
                    daysCircleView
                    
                    // Ultimi Allenamenti
                    // recentWorkoutsView
                }
                .padding(.horizontal, 20)
                .padding(.top, 1) // 👈 AGGIUNGI piccolo padding top per fix traslazione
            }
        }
        .navigationBarHidden(true) // 👈 SPOSTA qui
        .sheet(item: $selectedDay) { day in
            // 👈 CAMBIA: Usa NavigationView nel sheet invece
            NavigationView {
                WorkoutDayDetailView(workoutDay: day)
            }
        }
    }
    
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.11, green: 0.13, blue: 0.19),
                Color(red: 0.16, green: 0.50, blue: 0.73)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
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
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("GymBro")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your Training Partner")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Statistiche Overview
    private var statsOverviewView: some View {
        
        VStack {
            // Benvenuto
            VStack(spacing: 8) {
                Text(greetingMessage)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Pronto per l'allenamento?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }

            HStack(spacing: 16) {
                StatCircle(
                    value: "\(workoutPlan.days.count)",
                    label: "Giornate",
                    icon: "calendar.circle.fill",
                    color: .green
                )
                
                StatCircle(
                    value: "\(totalExercises)",
                    label: "Esercizi",
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                StatCircle(
                    value: "\(estimatedTime)",
                    label: "Minuti",
                    icon: "clock.fill",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Cerchi Giornate
    private var daysCircleView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Le Tue Giornate")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                ForEach(Array(workoutPlan.days.enumerated()), id: \.element.id) { index, day in
                    DayCircleView(
                        day: day,
                        gradient: dayGradients[index % dayGradients.count],
                        isAnimated: animationStates[day.id] ?? false
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            animationStates[day.id] = true
                            selectedDay = day
                        }
                        
                        // Reset animazione dopo un delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            animationStates[day.id] = false
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Ultimi Allenamenti
    private var recentWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ultime Sessioni")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Vedi Tutti") {
                    // Navigazione a storico completo
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 4)
            
            // Placeholder per ultime sessioni
            VStack(spacing: 12) {
                ForEach(0..<2) { _ in
                    RecentWorkoutRow()
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Buongiorno! ☀️"
        case 12..<18: return "Buon pomeriggio! 🌤️"
        case 18..<22: return "Buonasera! 🌙"
        default: return "Pronto ad allenarti! 💪"
        }
    }
    
    private var totalExercises: Int {
        workoutPlan.days.flatMap { $0.exercises }.count
    }
    
    private var estimatedTime: Int {
        // Stima 5 minuti per esercizio
        return totalExercises * 5
    }
}

// MARK: - Riga Ultimo Allenamento
struct RecentWorkoutRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Panca Piana")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text("ieri alle 18:30")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("4x8")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text("60 kg")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}
