//
//  EditSetView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 09/11/25.
//

import Foundation
import SwiftUI

struct EditSetView: View {
    // MARK: - Properties
    let exerciseName: String
    let muscleGroup: String
    let workoutSet: WorkoutSet
    
    @EnvironmentObject var historyManager: WorkoutHistoryManager
    @Binding var isPresented: Bool
    
    @State private var reps: String
    @State private var weight: String
    @State private var notes: String
    @State private var showError = false
    @FocusState private var focusedField: AddSetView.Field?
    
    init(exerciseName: String, muscleGroup: String, workoutSet: WorkoutSet, isPresented: Binding<Bool>) {
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.workoutSet = workoutSet
        self._isPresented = isPresented
        
        _reps = State(initialValue: "\(workoutSet.reps)")
        _weight = State(initialValue: String(format: "%.1f", workoutSet.weight))
        _notes = State(initialValue: workoutSet.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Header informativo
                infoSection
                
                // Sezione dati serie
                dataSection
                
                // Sezione note
                notesSection
                
                // Anteprima modifiche
                previewSection
            }
            .scrollContentBackground(.hidden) // Nasconde lo sfondo bianco di default
            .background(
                backgroundGradientForm
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Modifica")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        saveChanges()
                    }
                    .disabled(!isFormValid(reps: Int(reps), weight: Double(weight)))
                }
            }
            .alert("Errore", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Controlla i valori inseriti:\n- Ripetizioni devono essere un numero\n- Peso deve essere un numero valido")
            }
            .onAppear {
                // Focus automatico sul primo campo
                focusedField = .reps
            }
        }
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        Section(header: Text("Serie Originale")) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Data: \(formattedDate)")
                        .font(.subheadline)
                    
                    Text("Originale: \(workoutSet.reps) reps × \(workoutSet.weight, specifier: "%.1f") kg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundColor(.orange)
            }
        }
    }
    
    // MARK: - Data Section
    private var dataSection: some View {
        Section(header: Text("Nuovi Valori")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ripetizioni")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Ripetizioni", text: $reps)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .reps)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Peso (kg)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Peso", text: $weight)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .weight)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        Section(header: Text("Note")) {
            TextEditor(text: $notes)
                .frame(height: 80)
                .focused($focusedField, equals: .notes)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .padding(.vertical, 4)
        }
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        Section(header: Text("Anteprima Modifiche")) {
            if isFormValid(reps: Int(reps), weight: Double(weight)), let newReps = Int(reps), let newWeight = Double(weight) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Confronto")
                        .font(.headline)
                    
                    // Vecchi valori
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Prima")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(workoutSet.reps) reps")
                            Text("\(workoutSet.weight, specifier: "%.1f") kg")
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        // Nuovi valori
                        VStack(alignment: .trailing) {
                            Text("Dopo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(newReps) reps")
                                .foregroundColor(newReps > workoutSet.reps ? .green : .red)
                            Text("\(newWeight, specifier: "%.1f") kg")
                                .foregroundColor(newWeight > workoutSet.weight ? .green : .red)
                        }
                    }
                    
                    // Differenza volume
                    let oldVolume = Double(workoutSet.reps) * workoutSet.weight
                    let newVolume = Double(newReps) * newWeight
                    let volumeDiff = newVolume - oldVolume
                    
                    HStack {
                        Text("Volume:")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(oldVolume, specifier: "%.1f") → \(newVolume, specifier: "%.1f") kg")
                            .font(.subheadline)
                            .foregroundColor(volumeDiff > 0 ? .green : volumeDiff < 0 ? .red : .primary)
                        
                        Text("(\(volumeDiff > 0 ? "+" : "")\(volumeDiff, specifier: "%.1f"))")
                            .font(.caption)
                            .foregroundColor(volumeDiff > 0 ? .green : volumeDiff < 0 ? .red : .secondary)
                    }
                }
                .padding(.vertical, 8)
            } else {
                Text("Inserisci valori validi per vedere l'anteprima")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
    }
    // MARK: - Actions
    private func saveChanges() {
        guard let newReps = Int(reps), let newWeight = Double(weight) else {
            showError = true
            return
        }
        
        historyManager.updateSet(
            for: exerciseName,
            setId: workoutSet.id,
            newReps: newReps,
            newWeight: newWeight,
            newNotes: notes.isEmpty ? nil : notes
        )
        
        isPresented = false
        
        // Feedback haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Computed Properties
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: workoutSet.date)
    }
    
    // MARK: - Background
    var backgroundGradientForm: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.16, green: 0.50, blue: 0.73),  // Blu oceano
                headerIconColor(muscleGroup: muscleGroup).opacity(0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
