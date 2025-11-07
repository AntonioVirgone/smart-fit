//
//  WorkoutDayDetailView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation
import SwiftUI

struct WorkoutDayDetailView: View {
    let workoutDay: WorkoutDay
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                /*
                Text(workoutDay.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                */
                
                Text("\(workoutDay.exercises.count) exercizi in questa giornata")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .navigationTitle(workoutDay.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("📱 Aperta giornata: \(workoutDay.name)")
        }
    }
}

#Preview {
    WorkoutDayDetailView(workoutDay: WorkoutDay(name: "1", exercises: []))
}
