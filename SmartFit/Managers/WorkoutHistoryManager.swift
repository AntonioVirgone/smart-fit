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
        loadHistory()
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
    
    // MARK: - Recupera Storico per Esercizio
    func getHistory(for exerciseName: String) -> [WorkoutSet] {
        let history = workoutHistory[exerciseName] ?? []
        return history.sorted { $0.date > $1.date }
    }
    
    // MARK: - Elimina la serie
    func deleteSet(for exerciseName: String, setId: UUID) {
        workoutHistory[exerciseName]?.removeAll { $0.id == setId }
        saveHistory()
        print("🗑️ Serie eliminata per \(exerciseName)")
    }
    
    // MARK: - Statistiche
    func getStats(for exerciseName: String) -> (totalSets: Int, bestWeight: Double) {
        let history = getHistory(for: exerciseName)
        let totalSets = history.count
        let bestWeight = history.map { $0.weight }.max() ?? 0.0
        
        return (totalSets, bestWeight)
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
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            print("📝 Nessuno storico precedente trovato")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            workoutHistory = try decoder.decode([String: [WorkoutSet]].self, from: data)
            print("📖 Storico caricato: \(workoutHistory.count) esercizi con dati")
        } catch {
            print("❌ Errore caricamento storico: \(error)")
            workoutHistory = [:]
        }
    }
}

