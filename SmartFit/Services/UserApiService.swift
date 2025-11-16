//
//  UserApiService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
internal import Combine

class UserApiService: APIService {

    func signIn(user: User) {
        // URL dell'API di test
        guard let url = URL(string: "\(basePath)/users/signin") else {
            errorMessage = "URL non valido"
            isLoading = false
            isError = true
            return
        }
        
        print("🔗 Iniziando chiamata POST a: \(url)")
        isLoading = true

        // Crea la richiesta
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Converti i dati in JSON
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            
            // Stampa il body per debug
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Body della richiesta: \(jsonString)")
            }
        } catch {
            errorMessage = "Errore encoding dati: \(error.localizedDescription)"
            isLoading = false
            isError = true
            return
        }
        
        // Esegui la richiesta
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = true
                
                // Controlla se c'è un errore
                if let error = error {
                    self?.errorMessage = "Errore: \(error.localizedDescription)"
                    self?.isLoading = false
                    self?.isError = true
                    return
                }
                
                // Controlla la risposta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        self?.errorMessage = "Errore server: \(httpResponse.statusCode)"
                        self?.isLoading = false
                        self?.isError = true
                        return
                    } else {
                        self?.isLoading = false
                        self?.isError = false
                    }
                }
                print("✅ POST request completata con successo")
            }
        }
        
        // Avvia la chiamata
        task.resume()
    }
    
    func signUp(user: User) {
        // URL dell'API di test
        guard let url = URL(string: "\(basePath)/users/signup") else {
            errorMessage = "URL non valido"
            isLoading = false
            isError = true
            return
        }
        
        print("🔗 Iniziando chiamata POST a: \(url)")
        isLoading = true

        // Crea la richiesta
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Converti i dati in JSON
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            
            // Stampa il body per debug
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Body della richiesta: \(jsonString)")
            }
        } catch {
            errorMessage = "Errore encoding dati: \(error.localizedDescription)"
            isLoading = false
            isError = true
            return
        }
        
        // Esegui la richiesta
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = true
                
                // Controlla se c'è un errore
                if let error = error {
                    self?.errorMessage = "Errore: \(error.localizedDescription)"
                    self?.isLoading = false
                    self?.isError = true
                    return
                }
                
                // Controlla la risposta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        self?.errorMessage = "Errore server: \(httpResponse.statusCode)"
                        self?.isLoading = false
                        self?.isError = true
                        return
                    } else {
                        self?.isLoading = false
                        self?.isError = false
                    }
                }
                print("✅ POST request completata con successo")
            }
        }
        
        // Avvia la chiamata
        task.resume()
    }
}
