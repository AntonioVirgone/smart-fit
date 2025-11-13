//
//  TestPostApiView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 12/11/25.
//

import Foundation
import SwiftUI

struct TestPostApiView: View {
    @StateObject private var apiService = APIService()
    @StateObject private var historyManager = WorkoutHistoryManager()

    var body: some View {
        VStack {
            Button("Invia Dati Allenamento") {
                apiService.saveHistory(history: History(jsonData: HistoryWorkoutData(data: historyManager.getAllHistory()),
                                                        filename: "prova",
                                                        status: "prova"))
            }
            .buttonStyle(.borderedProminent)
            .disabled(!apiService.isLoading)
            
            if !apiService.isLoading {
                ProgressView("Invio dati...")
            }
            
            if let error = apiService.errorMessage {
                Text("Errore: \(error)")
                    .foregroundColor(.red)
            }
            
            Text(apiService.rawJSON)
                .font(.system(.caption, design: .monospaced))
                .padding()
        }
        .padding()
    }
}
