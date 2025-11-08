//
//  HistoryView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 08/11/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    // MARK: - Properties
    @EnvironmentObject var historyManager: WorkoutHistoryManager
    @State private var showingAddSet = false

    // MARK: - Computed Properties
    private var exerciseHistory: [WorkoutSet] {
        historyManager.getHistory(for: "")
    }
    
    private var stats: (totalSets: Int, bestWeight: Double) {
        historyManager.getStats(for: "")
    }

    var body: some View {
        ZStack {
            // Sfondo
            Color(.systemGroupedBackground).ignoresSafeArea()
            backgroundGradient
            
            ScrollView {
                VStack(spacing: 20) {
                    // Storico
                    historyCard
                }
                .padding()
            }
        }
        .navigationTitle("")
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
    
    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                
                Text("Storico Allenamenti")
                    .font(.headline)
                
                Spacer()
                
                Button("Aggiungi Serie") {
                    showingAddSet = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(exerciseHistory.count >= 10)
            }
            
            if exerciseHistory.isEmpty {
                emptyHistoryView
            } else {
                historyListView
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            
            Text("Nessun allenamento registrato")
                .font(.system(size:16))
                .foregroundColor(.secondary)
            
            Text("Inizia aggiungendo la tua prima serie!")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    private var historyListView: some View {
        LazyVStack(spacing: 12) {
            ForEach(exerciseHistory.prefix(5)) { workoutSet in
                HistoryRow(workoutSet: workoutSet) {
                    //deleteSet(workoutSet.id)
                }
            }
        }
    }

}
