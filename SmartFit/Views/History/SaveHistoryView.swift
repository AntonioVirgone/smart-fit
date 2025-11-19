//
//  TestPostApiView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 12/11/25.
//

import Foundation
import SwiftUI

struct TestPostApiView: View {
    @StateObject private var apiService = HistoryApiService()
    @StateObject private var historyManager = WorkoutHistoryManager()
    
    @State private var onClickRequest = false

    var body: some View {
        VStack {
            Button("Invia Dati Allenamento") {
                self.onClickRequest = true
                apiService.saveHistory(history: History(jsonData: HistoryWorkoutData(data: historyManager.getAllHistory()),
                                                        filename: "prova",
                                                        status: "prova"))
            }
            .buttonStyle(.borderedProminent)
            .disabled(apiService.isLoading)
            
            if apiService.isLoading {
                ProgressView("Invio dati...")
            }
            
            if let error = apiService.errorMessage {
                Text("Errore: \(error)")
                    .foregroundColor(.red)
            }
            
            if self.onClickRequest && !apiService.isLoading {
                Text("Dati caricati con successo!")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white)
            }
        }
    }
}
