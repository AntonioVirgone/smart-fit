//
//  ExerciseDetailView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 07/11/25.
//

import Foundation
import SwiftUI

struct ExerciseDetailView: View {
    // MARK: - Properties
    let exercise: Exercise
    @EnvironmentObject var historyManager: WorkoutHistoryManager
    @State private var showingAddSet = false
    @State private var newReps = "8"
    @State private var newWeight = "50"
    @State private var newNotes = ""
    
    // MARK: - Computed Properties
    private var exerciseHistory: [WorkoutSet] {
        historyManager.getHistory(for: exercise.name)
    }
    
    private var stats: (totalSets: Int, bestWeight: Double) {
        historyManager.getStats(for: exercise.name)
    }
    
    var body: some View {
        ZStack {
            // Sfondo
            Color(.systemGroupedBackground).ignoresSafeArea()
            backgroundGradient
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    exerciseHeader
                    
                    // Statistiche
                    statsCard
                    
                    // Istruzioni
                    instructionsCard
                    
                    // Storico
                    //historyCard
                }
                .padding()
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddSet) {
            /*
             AddSetView(
             exerciseName: exercise.name,
             reps: $newReps,
             weight: $newWeight,
             notes: $newNotes,
             isPresented: $showingAddSet,
             onSave: addNewSet
             )
             */
        }
    }
    
    // MARK: - Exercise Header
    private var exerciseHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(headerIconColor(muscleGroup: exercise.muscleGroup))
                    .frame(width: 80, height: 80)
                
                Image(systemName: headerIconName(muscleGroup: exercise.muscleGroup))
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            Text(exercise.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(exercise.muscleGroup)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Stats Card
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                
                Text("Statistiche")
                    .font(.headline)
                
                Spacer()
            }
            
            HStack {
                StatView(
                    value: "\(stats.totalSets)",
                    label: "Serie Totali",
                    icon: "number.circle.fill",
                    color: .green
                )
                
                StatView(
                    value: String(format: "%.1f", stats.bestWeight),
                    label: "Record (kg)",
                    icon: "trophy.fill",
                    color: .orange
                )
                
                StatView(
                    value: "\(exerciseHistory.count)",
                    label: "Sessioni",
                    icon: "calendar.circle.fill",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Instructions Card
    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "list.bullet.rectangle.fill")
                    .foregroundColor(.blue)
                
                Text("Istruzioni")
                    .font(.headline)
                    
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.blue))
                        
                        Text("\(instruction)")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Stat View Component
struct StatView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - History Row Component
struct HistoryRow: View {
    let workoutSet: WorkoutSet
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            
        }
    }
}
