//
//  SettingsView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 09/11/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var historyManager: WorkoutHistoryManager
    
    @State private var showingResetAlert = false
    @State private var showingResetSuccess = false
    @State private var showingExportSheet = false
    @State private var exportData: String = ""

    private var appVersion: (String, String) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return (version, build)
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                // Sezione Dati
                dataSection
                
                // Sezione Informazioni
                infoSection
            }
            .scrollContentBackground(.hidden) // Nasconde lo sfondo bianco di default
            .background(
                backgroundGradient
            )
            .navigationTitle("Impostazioni")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingExportSheet) {
                ExportDataView(exportData: exportData)
            }
            // Alert per reset dati
            .alert("Reset Storico", isPresented: $showingResetAlert) {
                Button("Annulla", role: .cancel) {
                    print("❌ Reset annullato dall'utente")
                }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("Sei sicuro di voler cancellare tutto lo storico degli allenamenti?\n\nQuesta azione non può essere annullata e tutti i tuoi dati andranno persi.")
            }
            // Alert di conferma reset
            .alert("Reset Completato", isPresented: $showingResetSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Tutti i dati dello storico sono stati cancellati con successo.")
            }
        }
    }
    
    // MARK: - Data Section
    private var dataSection: some View {
        Section(header: Text("Dati").foregroundColor(.white),
                footer: Text("Gestisci i tuoi dati di allenamento").foregroundColor(.white)) {
            Button("Esporta Dati") {
                exportUserData()
            }
            .foregroundColor(.primary)
            
            Button("Reset Storico", role: .destructive) {
                showingResetAlert = true
            }
            .foregroundColor(.red)
        }
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        Section(header: Text("Informazioni").foregroundColor(.white)) {
            HStack {
                Text("Versione")
                Spacer()
                Text(appVersion.0)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Build")
                Spacer()
                Text(appVersion.1)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Serie Totali Registrate")
                Spacer()
                Text("\(totalWorkoutSets)")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Esercizi Monitorati")
                Spacer()
                Text("\(trackedExercises)")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var totalWorkoutSets: Int {
        // Calcola il numero totale di serie in tutti gli esercizi
        return historyManager.getTotalWorkoutSets()
    }
    
    private var trackedExercises: Int {
        // Calcola il numero di esercizi con dati storici
        return historyManager.getTrackedExercisesCount()
    }
    
    // MARK: - Actions
    private func exportUserData() {
        // Prepara i dati per l'esportazione
        let exportResult = historyManager.exportAllData()
        exportData = exportResult
        showingExportSheet = true
        
        print("📤 Dati preparati per l'esportazione (\(exportData.count) caratteri)")
    }
    
    private func resetAllData() {
        // Esegui il reset dei dati
        historyManager.resetAllData()
        
        // Mostra conferma
        showingResetSuccess = true
        
        // Feedback haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        print("✅ Reset dati completato")
    }
}

// MARK: - Export Data View
struct ExportDataView: View {
    let exportData: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("I tuoi dati di allenamento")
                    .foregroundColor(.white)
                    .font(.headline)
                
                ScrollView {
                    Text(exportData)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                VStack(spacing: 12) {
                    Button("Copia negli Appunti") {
                        UIPasteboard.general.string = exportData
                        
                        // Feedback
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Condividi") {
                        shareData(exportData)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Esporta Dati")
            .scrollContentBackground(.hidden) // Nasconde lo sfondo bianco di default
            .background(
                backgroundGradient
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func shareData(_ data: String) {
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

