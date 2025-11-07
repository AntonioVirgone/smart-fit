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
                    // statsCard
                    
                    // Istruzioni
                    //instructionsCard
                    
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
        }
    }
    
}
