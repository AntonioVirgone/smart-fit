//
//  WorkoutApiService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
internal import Combine

class WorkoutApiService: APIService {
    // Funzione per fare la chiamata API
    func loadWorkoutData() {
        // URL dell'API di test
        guard let url = URL(string: "https://smartfit.altervista.org/page.php?file=1") else {
            errorMessage = "URL non valido"
            isLoading = false
            return
        }
        
        print("🔗 Iniziando chiamata API a: \(url)")
        
        // Crea la richiesta
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                // Controlla se c'è un errore
                if let error = error {
                    self?.errorMessage = "Errore: \(error.localizedDescription)"
                    self?.rawJSON = "Errore di rete"
                    return
                }
                
                // Controlla la risposta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                }
                
                // Controlla se ci sono dati
                guard let data = data else {
                    self?.errorMessage = "Nessun dato ricevuto"
                    self?.rawJSON = "Nessun dato"
                    return
                }
                
                // Stampa i dati raw per debug
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Ricevuto: \(jsonString)")
                    self?.rawJSON = jsonString
                }
                
                // Prova a convertire il JSON nel modello Swift
                do {
                    let decodedUsers = try JSONDecoder().decode(WorkoutPlan.self, from: data)
                    self?.workoutPlan = decodedUsers
                    self?.errorMessage = nil
                    self?.isLoading = false
                    print("✅ Successo! Trovati \(decodedUsers) utenti")
                } catch {
                    self?.errorMessage = "Errore decodifica: \(error.localizedDescription)"
                    print("❌ Errore decodifica: \(error)")
                }
            }
        }
        
        // Avvia la chiamata
        task.resume()
    }
    
}
