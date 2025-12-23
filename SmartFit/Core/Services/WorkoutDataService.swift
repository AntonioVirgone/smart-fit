//
//  WorkoutDataService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Combine
import Foundation

@MainActor
class WorkoutDataService: ObservableObject {

    // MARK: Published Properties
    @Published var workoutPlan: WorkoutPlan?
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?

    // MARK: Caricamento Dati
    func loadWorkoutData() {
        isLoading = true
        errorMessage = nil

        guard let url = Bundle.main.url(forResource: "workoutData", withExtension: "json") else {
            handleError("File workoutData.json non trovato nel bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let loadedPlan = try decoder.decode(WorkoutPlan.self, from: data)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.finishLoading(with: loadedPlan)
            }
        } catch let decodingError as DecodingError {
            handleDecodingError(decodingError)
        } catch {
            handleError("Errore generico: \(error.localizedDescription)")
        }
    }

    // MARK: - Helpers
    private func finishLoading(with plan: WorkoutPlan) {
        workoutPlan = plan
        isLoading = false
    }

    // MARK: - Gestione Errori di Decoding
    private func handleDecodingError(_ error: DecodingError) {
        let errorDescription: String

        switch error {
        case .keyNotFound(let key, let context):
            errorDescription = "🔑 Key non trovata: '\(key.stringValue)' in \(context.debugDescription)"
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
        errorMessage = message
        isLoading = false
    }
}
