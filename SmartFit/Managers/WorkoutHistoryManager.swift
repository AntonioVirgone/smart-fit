//
//  WorkoutHistoryManager.swift
//  SmartFit
//
//  Created by Antonio Virgone on 07/11/25.
//

import Foundation
internal import Combine

// MARK: - Manager per lo Storico Allenamenti (CRUD)
class WorkoutHistoryManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published private var workoutHistory: [String: [WorkoutSet]] = [:]
    
    // MARK: - Chiave per UserDefaults
    private let saveKey = "workoutHistory"
    
    // MARK: - Inizializzazione
    init() {
        //        loadHistory()
        print("📊 WorkoutHistoryManager inizializzato")
    }
    
    // MARK: - Aggiungi nuova serie
    func addSet(for exerciseName: String, reps: Int, weight: Double, notes: String? = nil) {
        let newSet = WorkoutSet(reps: reps, weight: weight, notes: notes)
        
        // Inizializzo l'array se non esiste
        if workoutHistory[exerciseName] == nil {
            workoutHistory[exerciseName] = []
        }
        
        // Aggiungo la serie all'array
        workoutHistory[exerciseName]?.append(newSet)
        
        // Salva l'history
        saveHistory()
        
        print("✅ Nuova serie aggiunta per \(exerciseName): \(reps) reps × \(weight) kg")
    }
    
    // MARK: Persistenza dei dati
    // In questo caso uso lo UserDefault, ma i dati rimangono salvati solo in locale finchè non viene cancellata l'app.
    private func saveHistory() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(workoutHistory)
            
            UserDefaults.standard.set(encodedData, forKey: saveKey)
            print("💾 Storico salvato (\(encodedData.count) bytes)")
        } catch {
            print("❌ Errore salvataggio storico: \(error)")
        }
    }
}
