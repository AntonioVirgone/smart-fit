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
    @State private var showingEditSet: WorkoutSet? = nil
    @State private var showingProgressChart = false
    
    @State private var newReps = "8"
    @State private var newWeight = "50"
    @State private var newNotes = ""
    @State private var isHeating = false

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
                    historyCard
                }
                .padding()
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddSet) {
            AddSetView(
                exerciseName: exercise.name,
                muscleGroup: exercise.muscleGroup,
                reps: $newReps,
                weight: $newWeight,
                notes: $newNotes,
                isPresented: $showingAddSet,
                isHeating: $isHeating,
                onSave: addNewSet
            )
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
    
    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                
                Text("Storico Allenamenti")
                    .font(.headline)
                
                Spacer()
                
                // Pulsante Grafico
                Button {
                    showingProgressChart = true
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
                .disabled(exerciseHistory.isEmpty)
                .buttonStyle(.bordered)
                .tint(.blue)
                
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
        .sheet(item: $showingEditSet) { setToEdit in
            EditSetView(
                exerciseName: exercise.name,
                muscleGroup: exercise.muscleGroup,
                workoutSet: setToEdit,
                isPresented: Binding(
                    get: { showingEditSet != nil },
                    set: { if !$0 { showingEditSet = nil } }
                )
            )
            .environmentObject(historyManager)
        }
        .sheet(isPresented: $showingProgressChart) {
            NavigationView {
                ProgressChartView(exerciseName: exercise.name)
                    .environmentObject(historyManager)
                    .navigationTitle("Progressi \(exercise.name)")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Chiudi") {
                                showingProgressChart = false
                            }
                        }
                    }
            }
        }
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
                    deleteSet(workoutSet.id)
                } onEdit: {
                    showingEditSet = workoutSet
                }
            }
            
            if exerciseHistory.count > 5 {
                Text("... e altre \(exerciseHistory.count - 5) serie")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    // MARK: - Actions
    private func addNewSet() {
        guard let reps = Int(newReps), let weight = Double(newWeight) else {
            print("❌ Valori non validi")
            return
        }
        
        historyManager.addSet(for: exercise.name, reps: reps, weight: weight, notes: newNotes.isEmpty ? nil : newNotes, type: isHeating ? .heating : .series)
        
        // Reset form
        newReps = "\(reps)"
        newWeight = "\(weight)"
        newNotes = ""
    }
    
    private func deleteSet(_ id: UUID) {
        historyManager.deleteSet(for: exercise.name, setId: id)
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
    let onEdit: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedDate)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                if let notes = workoutSet.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if workoutSet.type != nil {
                    Text(workoutSet.type == .series ? "Series" : "Repetizioni")
                }
                Text("\(workoutSet.reps) reps")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("\(workoutSet.weight, specifier: "%.1f") kg")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            // Menu Azioni invece del solo cestino
            Menu {
                Button {
                    onEdit() // 👈 NUOVA AZIONE
                } label: {
                    Label("Modifica", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Elimina", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .alert("Elimina Serie", isPresented: $showingDeleteAlert) {
            Button("Annulla", role: .cancel) { }
            Button("Elimina", role: .destructive, action: onDelete)
        } message: {
            Text("Vuoi eliminare questa serie?")
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: workoutSet.date)
    }
}
