//
//  TestApiConnectionView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 12/11/25.
//

import Foundation
import SwiftUI

struct TestApiConnectionView: View {
    @StateObject private var apiService = APIService()
    
    var body: some View {
        NavigationView {
            VStack {
                if apiService.isLoading {
                    ProgressView("Caricamento...")
                        .padding()
                } else if let error = apiService.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Errore")
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    // Visualizza il JSON raw
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("JSON Ricevuto:")
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            Text(apiService.rawJSON)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .textSelection(.enabled) // Permette di selezionare il testo
                        }
                        .padding()
                        
                        // Se vuoi mostrare anche i dati decodificati
                        if let workoutPlan = apiService.workoutPlan {
                            VStack(alignment: .leading) {
                                Text("Dati Decodificati:")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                Text("Workout Plan: \(workoutPlan.name)")
                                    .padding(.bottom, 2)
                                
                                // Aggiungi altri campi che vuoi mostrare
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("API Response")
            .toolbar {
                Button("Ricarica") {
                    apiService.loadWorkoutData()
                }
            }
        }
        .onAppear {
            if apiService.rawJSON == "Nessun dato caricato" {
                apiService.loadWorkoutData()
            }
        }
    }
}
