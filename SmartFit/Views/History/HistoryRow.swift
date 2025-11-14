//
//  HistoryRow.swift
//  SmartFit
//
//  Created by Antonio Virgone on 14/11/25.
//

import Foundation
import SwiftUI

// MARK: - History Row Component
struct HistoryRow: View {
    let textColor: Color
    let workoutSet: WorkoutSet
    let onDelete: () -> Void
    let onEdit: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedDate)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                if let notes = workoutSet.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 12))
                        .foregroundColor(textColor)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if workoutSet.type != nil {
                    Text(workoutSet.type == .series ? "Serie" : "Riscaldamento")
                        .foregroundColor(textColor)
                }
                Text("\(workoutSet.reps) reps")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                Text("\(workoutSet.weight, specifier: "%.1f") kg")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(textColor)
            }
            
            // Menu Azioni invece del solo cestino
            Menu {
                Button {
                    onEdit() // 👈 NUOVA AZIONE
                } label: {
                    Label("Modifica", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Elimina", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(colorSelector(level: workoutSet.intensity ?? WorkoutIntensity.light))
        .cornerRadius(8)
        .alert("Elimina Serie", isPresented: $showingDeleteAlert) {
            Button("Annulla", role: .cancel) { }
            Button("Elimina", role: .destructive, action: onDelete)
        } message: {
            Text("Vuoi eliminare questa serie?")
        }
    }
    
    
    private func colorSelector(level: WorkoutIntensity) -> Color {
        switch level {
        case .light: return Color.blue.opacity(0.2)
        case .moderate: return Color.purple.opacity(0.2)
        case .intense: return Color.red.opacity(0.2)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: workoutSet.date)
    }
}
