//
//  APIService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 10/11/25.
//

import Foundation
internal import Combine

class APIService: ObservableObject {
    @Published var workoutPlan: WorkoutPlan?
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var rawJSON: String = "Nessun dato caricato"
    
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
    
    func saveHistory(history: History) {
        // URL dell'API di test
        guard let url = URL(string: "https://smart-fit-api.onrender.com/api/history/save-json") else {
            errorMessage = "URL non valido"
            isLoading = false
            return
        }
        
        print("🔗 Iniziando chiamata API a: \(url)")

        // Crea la richiesta
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Converti i dati in JSON
        do {
            let jsonData = try JSONEncoder().encode(history)
            request.httpBody = jsonData
            
            // Stampa il body per debug
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Body della richiesta: \(jsonString)")
            }
        } catch {
            errorMessage = "Errore encoding dati: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        // Esegui la richiesta
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                // Controlla se c'è un errore
                if let error = error {
                    self?.errorMessage = "Errore: \(error.localizedDescription)"
                    return
                }
                
                // Controlla la risposta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        self?.errorMessage = "Errore server: \(httpResponse.statusCode)"
                        return
                    }
                }
                
                // Controlla se ci sono dati nella risposta
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Risposta POST: \(jsonString)")
                    self?.rawJSON = jsonString
                    
                    // Se la risposta contiene dati, puoi decodificarli qui
                    // self?.handlePostResponse(data)
                }
                
                print("✅ POST request completata con successo")
            }
        }
        
        // Avvia la chiamata
        task.resume()
    }
    
    // MARK: - Gestione risposta POST (esempio)
    private func handlePostResponse(_ data: Data) {
        do {
            // Esempio: decodifica una risposta di conferma
            let response = try JSONDecoder().decode(PostResponse.self, from: data)
            print("✅ Risposta POST: \(response)")
        } catch {
            print("❌ Errore decodifica risposta POST: \(error)")
        }
    }
    
    
    struct PostResponse: Codable {
        let success: Bool
        let message: String
        let id: String?
    }
}
