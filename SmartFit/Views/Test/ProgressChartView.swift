//
//  ProgressChartView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 09/11/25.
//

import Foundation
import SwiftUI
import Charts

struct ProgressChartView: View {
    
    // MARK: - Properties
    let exerciseName: String
    @EnvironmentObject var historyManager: WorkoutHistoryManager
    
    @State private var selectedTimeFrame: TimeFrame = .month
    @State private var chartData: [ChartDataPoint] = []
    
    enum TimeFrame: String, CaseIterable {
        case week = "Settimana"
        case month = "Mese"
        case threeMonths = "3 Mesi"
        case year = "Anno"
        
        var timeInterval: TimeInterval {
            switch self {
            case .week: return 7 * 24 * 3600
            case .month: return 30 * 24 * 3600
            case .threeMonths: return 90 * 24 * 3600
            case .year: return 365 * 24 * 3600
            }
        }
    }
    
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let weight: Double
        let volume: Double
        let reps: Int
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header e selezione periodo
            headerView
            
            if chartData.isEmpty {
                emptyChartView
            } else {
                chartContentView
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .onAppear {
            loadChartData()
        }
        .onChange(of: selectedTimeFrame) {
            loadChartData()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Andamento Progressi")
                    .font(.headline)
                
                Text(exerciseName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Picker("Periodo", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                    Text(timeFrame.rawValue).tag(timeFrame)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    // MARK: - Empty Chart View
    private var emptyChartView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("Dati insufficienti")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Aggiungi più allenamenti per vedere i grafici")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Chart Content View
    private var chartContentView: some View {
        VStack(spacing: 20) {
            // Grafico Peso
            VStack(alignment: .leading, spacing: 8) {
                Text("Peso Massimo (kg)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Chart(chartData) { dataPoint in
                    LineMark(
                        x: .value("Data", dataPoint.date),
                        y: .value("Peso", dataPoint.weight)
                    )
                    .foregroundStyle(.blue.gradient)
                    
                    PointMark(
                        x: .value("Data", dataPoint.date),
                        y: .value("Peso", dataPoint.weight)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 150)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, style: .date)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            
            // Statistiche Riassuntive
            summaryStatsView
        }
    }
    
    // MARK: - Summary Stats View
    private var summaryStatsView: some View {
        let progress = historyManager.calculateProgress(of: exerciseName, period: selectedTimeFrame.timeInterval)
        
        return HStack(spacing: 16) {
            StatBox(
                title: "Progresso Peso",
                value: String(format: "%.1f%%", progress.weightProgress),
                icon: "scalemass.fill",
                color: progress.weightProgress >= 0 ? .green : .red
            )
            
            StatBox(
                title: "Progresso Volume",
                value: String(format: "%.1f%%", progress.volumeProgress),
                icon: "chart.bar.fill",
                color: progress.volumeProgress >= 0 ? .green : .red
            )
        }
    }
    
    // MARK: - Data Loading
    private func loadChartData() {
        let endDate = Date()
        let startDate = Date(timeIntervalSinceNow: -selectedTimeFrame.timeInterval)
        
        let history = historyManager.getHistoryInDateRange(for: exerciseName, from: startDate, endDate: endDate)
        
        // Raggruppa per data e trova il massimo per ogni giorno
        let groupedByDate = Dictionary(grouping: history) { workoutSet in
            Calendar.current.startOfDay(for: workoutSet.date)
        }
        
        chartData = groupedByDate.map { (date: Date, sets: [WorkoutSet]) -> ChartDataPoint in
            // Calcola il peso massimo
            let maxWeight: Double = sets.map { $0.weight }.max() ?? 0.0
            
            // Calcola il volume totale (peso × ripetizioni)
            let totalVolume: Double = sets.reduce(0.0) { partial, set in
                partial + (Double(set.reps) * set.weight)
            }
            
            // Calcola il massimo numero di ripetizioni
            let maxReps: Int = sets.map { $0.reps }.max() ?? 0
            
            // Ritorna un punto del grafico
            return ChartDataPoint(date: date, weight: maxWeight, volume: totalVolume, reps: maxReps)
        }
        .sorted { $0.date < $1.date }
        
        print("📈 Caricati \(chartData.count) punti dati per il grafico")
    }
}

// MARK: - Stat Box Component
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
