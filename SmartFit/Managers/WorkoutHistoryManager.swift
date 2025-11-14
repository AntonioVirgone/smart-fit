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
    func addSet(for exerciseName: String, reps: Int, weight: Double, notes: String? = nil, type: WorkoutType? = nil, intensity: WorkoutIntensity? = nil) {
        let newSet = WorkoutSet(reps: reps, weight: weight, notes: notes, type: type, intensity: intensity)
        
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
    
    // MARK: - Modifica Serie Esistenti
    func updateSet(for exerciseName: String, setId: UUID, newReps: Int, newWeight: Double, newNotes: String? = nil) {
        guard var sets = workoutHistory[exerciseName],
              let index = sets.firstIndex(where: { $0.id == setId }) else {
            print("❌ Serie non trovata per l'aggiornamento")
            return
        }
        
        // Crea una copia aggiornata della serie
        var updatedSet = sets[index]
        updatedSet.reps = newReps
        updatedSet.weight = newWeight
        updatedSet.notes = newNotes
        
        // Sostituisce la serie nell'array
        sets[index] = updatedSet
        workoutHistory[exerciseName] = sets
        
        // Salva le modifiche
        saveHistory()
        
        print("🔄 Serie aggiornata per \(exerciseName)")
    }
    
    // MARK: - Recupera Storico per Esercizio
    func getHistory(for exerciseName: String) -> [WorkoutSet] {
        let history = workoutHistory[exerciseName] ?? []
        return history.sorted { $0.date > $1.date }
    }
    
    // MARK: - Ricerca e Filtri
    func getRecentHistory(for exerciseName: String, limit: Int = 10) -> [WorkoutSet] {
        let allHistory = getHistory(for: exerciseName)
        return Array(allHistory.prefix(limit))
    }
    
    func getHistoryInDateRange(for exerciseName: String, from startDate: Date, endDate: Date) -> [WorkoutSet] {
        let allHistory = getHistory(for: exerciseName)
        return allHistory.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    func getAllHistory() -> [String: [WorkoutSet]] {
        return workoutHistory
    }
    
    // MARK: - Calcolo Progressi
    func calculateProgress(of exerciseName: String, period: TimeInterval = 30 * 24 * 3600) -> (weightProgress: Double, volumeProgress: Double) {
        let now = Date()
        let pastDate = Date(timeIntervalSinceNow: -period)
        
        let recentSets = getHistoryInDateRange(for: exerciseName, from: pastDate, endDate: now)
        let olderSets = getHistoryInDateRange(for: exerciseName, from: Date(timeIntervalSinceNow: -2 * period), endDate: pastDate)
        
        let recentMaxWeight = recentSets.map { $0.weight }.max() ?? 0.0
        let olderMaxWeight = olderSets.map { $0.weight }.max() ?? 0.0
       
        let recentVolume = recentSets.reduce(0.0) { $0 + (Double($1.reps) * $1.weight) }
        let olderVolume = olderSets.reduce(0.0) { $0 + (Double($1.reps) * $1.weight) }

        let weightProgress = olderMaxWeight > 0 ? (recentMaxWeight - olderMaxWeight) / olderMaxWeight * 100 : 0
        let volumeProgress = olderVolume > 0 ? (recentVolume - olderVolume) / olderVolume * 100 : 0
        
        return (weightProgress, volumeProgress)
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
    
    // MARK: - Statistiche Globali
    func getTotalWorkoutSets() -> Int {
        return workoutHistory.values.reduce(0) { $0 + $1.count }
    }

    func getTrackedExercisesCount() -> Int {
        return workoutHistory.keys.count
    }

    func getMostPerformedExercise() -> (name: String, count: Int) {
        guard let maxEntry = workoutHistory.max(by: { $0.value.count < $1.value.count }) else {
            return ("Nessuno", 0)
        }
        
        return (maxEntry.key, maxEntry.value.count)
    }

    // MARK: - Esportazione Dati
    func exportAllData() -> String {
        var exportString = "GymBro - Esportazione Dati\n"
        exportString += "Data: \(Date())\n"
        exportString += "====================\n\n"
        
        for (exerciseName, sets) in workoutHistory.sorted(by: { $0.key < $1.key }) {
            exportString += "\(exerciseName)\n"
            exportString += "\(String(repeating: "-", count: exerciseName.count))\n"
            
            for set in sets.sorted(by: { $0.date > $1.date }) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                
                exportString += "  \(dateFormatter.string(from: set.date)) - "
                exportString += "\(set.reps) reps × \(set.weight, default: "%.1f") kg"
                
                if let notes = set.notes, !notes.isEmpty {
                    exportString += " - \(notes)"
                }
                
                exportString += "\n"
            }
            exportString += "\n"
        }
        
        // Statistiche finali
        exportString += "STATISTICHE FINALI\n"
        exportString += "====================\n"
        exportString += "Serie totali: \(getTotalWorkoutSets())\n"
        exportString += "Esercizi monitorati: \(getTrackedExercisesCount())\n"
        
        let mostPerformed = getMostPerformedExercise()
        exportString += "Esercizio più frequente: \(mostPerformed.name) (\(mostPerformed.count) serie)\n"
        
        return exportString
    }

    // MARK: - Reset Dati
    func resetAllData() {
        workoutHistory.removeAll()
        saveHistory()
        print("🗑️ Tutti i dati storici sono stati resettati")
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

