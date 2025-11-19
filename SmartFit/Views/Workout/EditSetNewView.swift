//
//  AddSetView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 08/11/25.
//

import Foundation
import SwiftUI

struct EditSetNewView: View {
    // MARK: - Properties
    let exerciseName: String
    let muscleGroup: String
    let workoutSet: WorkoutSet

    @State var reps: String
    @State var weight: String
    @State var notes: String
    @Binding var isPresented: Bool
    @State var isHeating: Bool
    @State var intensity: WorkoutIntensity
    
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var historyManager: WorkoutHistoryManager

    enum Field {
        case reps, weight, notes
    }
    
    init(exerciseName: String, muscleGroup: String, workoutSet: WorkoutSet, isPresented: Binding<Bool>) {
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.workoutSet = workoutSet
        self._isPresented = isPresented
        
        _isHeating = State(initialValue: workoutSet.type == .heating)
        _reps = State(initialValue: "\(workoutSet.reps)")
        _weight = State(initialValue: String(format: "%.1f", workoutSet.weight))
        _notes = State(initialValue: workoutSet.notes ?? "")
        _intensity = State(initialValue: workoutSet.intensity ?? .light)
    }

    var body: some View {
        NavigationView{
            Form {
                // Sezione scelta tipo
                toggleHeating
                
                // Sezione intensità
                intensitySelector

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
    
    private var intensitySelector: some View {
        Section(header: Text("Intensità")) {
            HStack(spacing: 12) {
                ForEach(WorkoutIntensity.allCases, id: \.self) { level in
                    Text(level.rawValue)
                        .font(.system(size: 12))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            colorSelector(level: level)
                        )
                        .foregroundStyle(intensity == level ? .white : .primary)
                        .cornerRadius(12)
                        .onTapGesture {
                            intensity = level
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .animation(.spring(), value: intensity)
        }
    }
    
    private func colorSelector(level: WorkoutIntensity) -> Color {
        if intensity == level {
            switch level {
            case .light: return Color.blue
            case .moderate: return Color.purple
            case .intense: return Color.red
            }
        }
        return Color.gray.opacity(0.2)
    }
    
    private var toggleHeating: some View {
        Section(header: Text("Tipo Serie")) {
            Toggle("Riscaldamento", isOn: $isHeating).padding()
        }
    }
    
    // MARK: - Data Section
    private var dataSection: some View {
        Section(header: Text("Dati Serie")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ripetizioni")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Es. 8", text: $reps)
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
                
                TextField("Es: 50.5", text: Binding(get: { weight }, set: { newValue in
                    weight = newValue.replacingOccurrences(of: ",", with: ".")
                }))
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
        Section(header: Text("Note Opzionali")) {
            TextEditor(text: $notes)
                .frame(height: 100)
                .focused($focusedField, equals: .notes)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .padding(.vertical, 4)
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
            newReps: Int(newReps),
            newWeight: Double(newWeight),
            newNotes: notes.isEmpty ? nil : notes,
            type: isHeating ? .heating : .series,
            intensity: intensity
        )
        
        isPresented = false
        
        // Feedback haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
}
