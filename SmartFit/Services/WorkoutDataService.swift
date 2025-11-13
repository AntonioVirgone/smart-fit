//
//  WorkoutDataService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
internal import Combine

class WorkoutDataService: ObservableObject {
    
    // MARK: Published Properties
    @Published var workoutPlan: WorkoutPlan?
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    // MARK: Caricamento Dati
    func loadWorkoutData() {
        print("🔄 Inizio caricamento dati...")
        
        // 1. Trova il file json nel bundle
        guard let url = Bundle.main.url(forResource: "workoutData_grazi", withExtension: "json") else {
            print("File non trovato")
            return
        }
        
        print("📁 File JSON trovato: \(url.path)")
        
        do {
            // 2. Leggi i dati dal file
            let data = try Data(contentsOf: url)
            print("📦 Dati letti: \(data.count) bytes")
            
            // 3. Decodifica il JSON
            let decoder = JSONDecoder()
            let loadedPlan = try decoder.decode(WorkoutPlan.self, from: data)
            
            // Simula un ritardo di rete di 2 secondi
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("✅ JSON decodificato con successo!")
                print("📊 Nome scheda: \(loadedPlan.name)")
                print("📅 Giornate caricate: \(loadedPlan.days.count)")
                
                self.workoutPlan = loadedPlan
                self.isLoading = false
            }
        } catch let decodingError as DecodingError {
            // Errore di decoding specifico
            handleDecodingError(decodingError)
        } catch {
            // Altri errori
            handleError("Errore generico: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Gestione Errori di Decoding
        private func handleDecodingError(_ error: DecodingError) {
            var errorDescription = ""
            
            switch error {
            case .keyNotFound(let key, let context):
                errorDescription = "🔑 Key non trovata: '\(key)' in \(context.debugDescription)"
            case .typeMismatch(let type, let context):
                errorDescription = "🔄 Type mismatch: \(type) in \(context.debugDescription)"
            case .valueNotFound(let type, let context):
                errorDescription = "❓ Value non trovato: \(type) in \(context.debugDescription)"
            case .dataCorrupted(let context):
                errorDescription = "📛 Data corrotta: \(context.debugDescription)"
            @unknown default:
                errorDescription = "❔ Errore sconosciuto di decoding"
            }
            
            handleError(errorDescription)
        }
        
        // MARK: - Gestione Errori Generici
        private func handleError(_ message: String) {
            print("❌ Errore: \(message)")
            
            DispatchQueue.main.async {
                self.errorMessage = message
                self.isLoading = false
                
                // Fallback ai dati mock
                self.simulateDataLoad()
            }
        }
    
    // MARK: Simulazione caricamento dati. NON IN USO
    private func simulateDataLoad() {
        // Questo è dati mock - nella prossima fase lo sostituiremo con JSON
        let mockExercises = [
            Exercise(
                name: "Panca Piana",
                description: "Esercizio fondamentale per i pettorali",
                imageName: "bench_press",
                muscleGroup: "Pettorali",
                instructions: [
                    "Sdraiati sulla panca con i piedi per terra",
                    "Impugna il bilanciere con presa media",
                    "Abbassa lentamente il bilanciere al petto",
                    "Spingi verso l'alto con controllo"
                ]
            )
        ]
        
        let mockDay = WorkoutDay(
            name: "Giornata 1 - Petto e Tricipiti",
            exercises: mockExercises
        )
        
        let mockPlan = WorkoutPlan(
            name: "Scheda Palestra",
            days: [mockDay]
        )
        
        // Simula un ritardo di rete di 2 secondi
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("✅ Dati caricati con successo!")
            self.workoutPlan = mockPlan
            self.isLoading = false
        }
    }
}
