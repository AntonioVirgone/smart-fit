//
//  AddSetView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 08/11/25.
//

import Foundation
import SwiftUI

struct AddSetView: View {
    // MARK: - Properties
    let exerciseName: String
    let muscleGroup: String
    @Binding var reps: String
    @Binding var weight: String
    @Binding var notes: String
    @Binding var isPresented: Bool
    let onSave: () -> Void
    
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case reps, weight, notes
    }
    
    var body: some View {
        NavigationView{
            Form {
                // Sezione dati serie
                dataSection
                
                // Sezione note
                notesSection
                
                // Validazione
                validationSection
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
                    Text("Nuova Serie")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        saveSet()
                    }
                    .disabled(!isFormValid)
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
                
                TextField("Es: 50.5", text: $weight)
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
    
    // MARK: - Validation Section
        private var validationSection: some View {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Riepilogo")
                        .font(.headline)
                    
                    if let repsInt = Int(reps), let weightDouble = Double(weight) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(repsInt) ripetizioni")
                                    .font(.subheadline)
                                Text("\(weightDouble, specifier: "%.1f") kg")
                                    .font(.subheadline)
                                Text("Volume: \(Double(repsInt) * weightDouble, specifier: "%.1f") kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                    } else {
                        HStack {
                            Text("Inserisci valori validi")
                                .font(.subheadline)
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    
    // MARK: - Form Validation
    private var isFormValid: Bool {
        guard let repsInt = Int(reps), let weightDouble = Double(weight) else {
            return false
        }
        
        return repsInt > 0 && weightDouble >= 0
    }
    
    // MARK: - Actions
    private func saveSet() {
        guard isFormValid else {
            showError = true
            return
        }
        
        onSave()
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

}
