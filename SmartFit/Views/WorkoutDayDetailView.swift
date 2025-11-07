//
//  WorkoutDayDetailView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

struct WorkoutDayDetailView: View {
    let workoutDay: WorkoutDay
    
    var body: some View {
        ZStack {
            // Sfondo gradient
            backgroundGradient
            
            VStack {
                Text(workoutDay.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Text("\(workoutDay.exercises.count) exercizi in questa giornata")
                    .foregroundColor(.secondary)
                
                exercisesList
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Exercises List
    private var exercisesList: some View {
        List(workoutDay.exercises) { exercise in
            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                ExerciseRowView(exercise: exercise)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        ZStack {
            // Card design
            cardDesign
            
            // Contenuto
            HStack(spacing: 16) {
                // Icona
                exerciseIcon

                // Informazioni
                exerciseInfo
                
                Spacer()
                
                // Freccia di navigazione
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Exercise Icon
    private var exerciseIcon: some View {
        ZStack {
            Circle()
                .fill(iconBackgroundColor)
                .frame(width: 50, height: 50)
            
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Exercise Info
        private var exerciseInfo: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(exercise.muscleGroup)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(exercise.instructions.count) istruzioni")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    
    // MARK: - Helpers
    private var iconName: String {
        switch exercise.muscleGroup {
        case "Pettorali":
            return "figure.strengthtraining.traditional"
        case "Dorsali":
            return "figure.rower"
        case "Bicipiti", "Tricipiti":
            return "figure.arms.open"
        case "Gambe":
            return "figure.run"
        case "Addominali":
            return "figure.core.training"
        default:
            return "dumbbell.fill"
        }
    }

    private var iconBackgroundColor: Color {
        switch exercise.muscleGroup {
        case "Pettorali": return .blue
        case "Dorsali": return .green
        case "Bicipiti": return .orange
        case "Tricipiti": return .purple
        case "Gambe": return .red
        case "Addominali": return .indigo
        default: return .gray
        }
    }

}
