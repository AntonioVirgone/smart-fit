//
//  HomeView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI
//
//  HomeView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    let workoutPlan: WorkoutPlan
   
    @State private var selectedDay: WorkoutDay?
    @State private var animationStates: [UUID: Bool] = [:]
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: Greeting
                greetingSection
                
                // MARK: Stats Overview
                statsSection
                
                // MARK: Workout Days
                daysSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .sheet(item: $selectedDay) { day in
            NavigationView {
                WorkoutDayDetailView(workoutDay: day)
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(greetingMessage)
                .font(.system(size: 26, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Pronto per l'allenamento?")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private var statsSection: some View {
        VStack(spacing: 16) {
            
            StatCardView(
                value: "\(workoutPlan.days.count)",
                label: "Giornate",
                icon: "calendar.circle.fill",
                color: .green
            )
            
            HStack(spacing: 16) {
                StatCardView(
                    value: "\(totalExercises)",
                    label: "Esercizi",
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                StatCardView(
                    value: "\(estimatedTime)",
                    label: "Minuti",
                    icon: "clock.fill",
                    color: .orange
                )
            }
        }
    }

    private var daysSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text(workoutPlan.name)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(workoutPlan.days.enumerated()), id: \.element.id) { index, day in
                        
                        DiscoverCardView(
                            title: day.name,
                            exercises: day.exercises.count,
                            minutes: day.exercises.count * 5,
                            color: cardColor(for: index),
                            isAnimated: animationStates[day.id] ?? false
                        ) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                animationStates[day.id] = true
                                selectedDay = day
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationStates[day.id] = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func cardColor(for index: Int) -> Color {
        let palette: [Color] = [
            Color.blue.opacity(0.8),
            Color.green.opacity(0.8),
            Color.orange.opacity(0.8),
            Color.pink.opacity(0.8)
        ]
        return palette[index % palette.count]
    }

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
        workoutPlan.days.reduce(0) { $0 + $1.exercises.count }
    }

    private var estimatedTime: Int {
        totalExercises * 5
    }

}

