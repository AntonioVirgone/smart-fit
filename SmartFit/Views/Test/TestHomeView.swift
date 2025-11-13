//
//  NewHomeView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

struct TestHomeView: View {
    let workoutPlan: WorkoutPlan
    @State private var selectedDay: WorkoutDay?
    @State private var animationStates: [UUID: Bool] = [:]
    @State private var showingMenu = false
    
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
            // Sfondo gradient
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
                .padding(.top, 10)
            }
            
            // 👈 MENU OVERLAY A LIVELLO DI ZSTACK - sopra tutto
            if showingMenu {
                menuOverlay
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedDay) { day in
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
    
    // MARK: - Header con Logo e Burger Menu (SENZA overlay)
    private var headerView: some View {
        VStack(spacing: 16) {
            // Logo App con Burger Menu
            HStack(spacing: 12) {
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
                
                // Logo
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
                
                // Spazio bilanciamento
                Circle()
                    .fill(Color.clear)
                    .frame(width: 44, height: 44)
            }
            .padding(.top, 10)
            
            // Benvenuto
            VStack(spacing: 8) {
                Text(greetingMessage)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Pronto per l'allenamento?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        // 👈 RIMOSSO l'overlay da qui
    }
    
    // MARK: - Menu Overlay (versione corretta)
    private var menuOverlay: some View {
        ZStack {
            // Sfondo semi-trasparente che copre TUTTO lo schermo
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingMenu = false
                    }
                }
            
            // Contenuto del menu
            VStack(alignment: .leading, spacing: 0) {
                // Spazio per il safe area
                Color.clear
                    .frame(height: 60)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header Menu
                    HStack {
                        Text("Menu")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingMenu = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    // Voci Menu
                    LazyVStack(spacing: 0) {
                        MenuRow(
                            icon: "person.circle.fill",
                            title: "Profilo",
                            color: .blue,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                                // Naviga al profilo
                            }
                        )
                        
                        MenuRow(
                            icon: "chart.bar.fill",
                            title: "Statistiche Avanzate",
                            color: .green,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                                // Naviga alle statistiche
                            }
                        )
                        
                        MenuRow(
                            icon: "clock.arrow.circlepath",
                            title: "Cronologia Allenamenti",
                            color: .orange,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                                // Naviga alla cronologia
                            }
                        )
                        
                        MenuRow(
                            icon: "heart.circle.fill",
                            title: "Preferiti",
                            color: .red,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                                // Naviga ai preferiti
                            }
                        )
                        
                        MenuRow(
                            icon: "gearshape.fill",
                            title: "Impostazioni",
                            color: .gray,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                                // Naviga alle impostazioni
                            }
                        )
                    }
                    
                    // Footer Menu
                    VStack(spacing: 12) {
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        HStack {
                            Text("GymBro v1.0")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Spacer()
                            
                            Text("by Il Tuo Nome")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.17, blue: 0.23),
                            Color(red: 0.11, green: 0.13, blue: 0.19)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .zIndex(1000) // 👈 ASSICURA che il menu sia sopra tutto
    }
    
    // MARK: - Statistiche Overview
    private var statsOverviewView: some View {
        VStack {
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
                    // 👈 USA NavigationLink invece di sheet per navigazione corretta
                    NavigationLink(destination: WorkoutDayDetailView(workoutDay: day)) {
                        DayCircleView(
                            day: day,
                            gradient: dayGradients[index % dayGradients.count],
                            isAnimated: animationStates[day.id] ?? false
                        ) {
                            // Animazione al tap
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                animationStates[day.id] = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animationStates[day.id] = false
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // 👈 Importante per disabilitare lo stile default
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
        return totalExercises * 5
    }
}

// MARK: - Componente Cerchio Giornata
struct DayCircleView: View {
    let day: WorkoutDay
    let gradient: LinearGradient
    let isAnimated: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    // Cerchio principale
                    Circle()
                        .fill(gradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .scaleEffect(isAnimated ? 0.9 : 1.0)
                    
                    // Icona
                    Image(systemName: dayIcon)
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimated ? 1.1 : 1.0)
                }
                
                // Informazioni
                VStack(spacing: 4) {
                    Text(day.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("\(day.exercises.count) esercizi")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(height: 50)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var dayIcon: String {
        let dayName = day.name.lowercased()
        if dayName.contains("petto") || dayName.contains("petto") {
            return "figure.strengthtraining.traditional"
        } else if dayName.contains("dorsali") || dayName.contains("dorso") {
            return "figure.rower"
        } else if dayName.contains("gambe") {
            return "figure.run"
        } else if dayName.contains("bicipiti") {
            return "figure.arms.open"
        } else {
            return "dumbbell.fill"
        }
    }
}

// MARK: - Componente Statistica Cerchio
struct StatCircle: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Componente Riga Menu
struct MenuRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Feedback aptico
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(isPressed ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 50, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Button Style per Animazioni
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct TestHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockExercise = Exercise(
            name: "Panca Piana",
            description: "Esercizio per i pettorali",
            imageName: "bench_press",
            muscleGroup: "Pettorali",
            instructions: ["Istruzione 1", "Istruzione 2"]
        )
        
        let mockDays = [
            WorkoutDay(name: "GIORNO 1 - Petto e Tricipiti", exercises: [mockExercise, mockExercise]),
            WorkoutDay(name: "GIORNO 2 - Dorsali e Bicipiti", exercises: [mockExercise]),
            WorkoutDay(name: "GIORNO 3 - Gambe e Spalle", exercises: [mockExercise, mockExercise, mockExercise])
        ]
        
        let mockPlan = WorkoutPlan(name: "Scheda Preview", days: mockDays)
        
        return NavigationView {
            TestHomeView(workoutPlan: mockPlan)
        }
    }
}
