//
//  HistoryView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 14/11/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @StateObject private var historyManager = WorkoutHistoryManager()
    @State private var showingEditSet: WorkoutSet? = nil

    private var exerciseHistory: [String: [WorkoutSet]] {
        historyManager.getAllHistory()
    }
    
    var body: some View {
        historyCard
        Spacer()
    }
    
    private func header(key: String) -> some View {
        Text(key)
            .foregroundColor(.primary.opacity(0.7))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
    
    private var historyCard: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                
                Text("Storico Allenamenti")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            
            if exerciseHistory.isEmpty {
                emptyHistoryView
            } else {
                List {
                    ForEach(exerciseHistory.keys.sorted(), id: \.self) { key in
                        Section(header: header(key: key)) {
                            ForEach(exerciseHistory[key] ?? []  as [WorkoutSet], id: \.id) { set in
                                HistoryRow(textColor: .white,
                                           workoutSet: set) {
                                    deleteSet(for: key, id: set.id)
                                } onEdit: {
                                    showingEditSet = set
                                }
                                .listRowBackground(Color.clear)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Rimuove lo stile predefinito della lista
                .scrollContentBackground(.hidden) // Nasconde lo sfondo della lista
            }
        }
        .padding()
        .cornerRadius(12)
    }
    
    private func deleteSet(for name: String, id: UUID) {
        historyManager.deleteSet(for: name, setId: id)
    }
}

private var emptyHistoryView: some View {
    VStack(spacing: 12) {
        Image(systemName: "chart.bar.doc.horizontal")
            .font(.system(size: 40))
            .foregroundColor(.secondary)
        
        Text("Nessun allenamento registrato")
            .font(.system(size:16))
            .foregroundColor(.secondary)
        
        Text("Inizia aggiungendo la tua prima serie!")
            .font(.system(size: 14))
            .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 30)
}
