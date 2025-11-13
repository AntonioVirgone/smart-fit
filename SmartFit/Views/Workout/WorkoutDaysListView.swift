//
//  WorkoutDaysListView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

struct WorkoutDaysListView: View {
    // MARK: Properties
    let workoutPlan: WorkoutPlan
    
    // MARK: Body
    var body: some View {
        NavigationView{
            ZStack {
                // Sfondo gradient
                backgroundGradient
                
                // Lista delle giornate
                daysList
            }
        }
    }
    
    // MARK: Days List
    private var daysList: some View {
        List(workoutPlan.days) { day in
            NavigationLink(destination: WorkoutDayDetailView(workoutDay: day)) {
                DayRowView(day: day)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle()) // Rimuove lo stile predefinito della lista
        .scrollContentBackground(.hidden) // Nasconde lo sfondo della lista
    }
}

struct DayRowView: View {
    let day: WorkoutDay
    
    var body: some View {
        ZStack {
            // Card design
            cardDesign
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(day.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(day.exercises.count) esercizi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}
