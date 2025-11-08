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
                Text("\(workoutDay.exercises.count) exercizi in questa giornata")
                    .foregroundColor(.white)
                
                exercisesList
                
                Spacer()
            }
        }
        .navigationTitle(workoutDay.name)
        .navigationBarTitleDisplayMode(.inline)
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
                .fill(headerIconColor(muscleGroup: exercise.muscleGroup))
                .frame(width: 50, height: 50)
            
            Image(systemName: headerIconName(muscleGroup: exercise.muscleGroup))
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
    

}
