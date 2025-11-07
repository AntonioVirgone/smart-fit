//
//  WorkoutModels.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/11/25.
//

import Foundation

// MARK: - Modello Esercizio
struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let imageName: String
    let muscleGroup: String
    let instructions: [String]
    
    // Inizializzatore personalizzato
    init(id: UUID = UUID(),
         name: String,
         description: String,
         imageName: String,
         muscleGroup: String,
         instructions: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.muscleGroup = muscleGroup
        self.instructions = instructions
    }
}

// MARK: - Modello Giornata Allenamento
struct WorkoutDay: Identifiable, Codable {
    let id: UUID
    let name: String
    let exercises: [Exercise]
    
    init(id: UUID = UUID(), name: String, exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}

// MARK: - Modello Piano Allenamento
struct WorkoutPlan: Codable {
    let name: String
    let days: [WorkoutDay]
}

// MARK: - Modello Serie di Allenamento
struct WorkoutSet: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var reps: Int
    var weight: Double
    var notes: String?
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         reps: Int,
         weight: Double,
         notes: String? = nil) {
        self.id = id
        self.date = date
        self.reps = reps
        self.weight = weight
        self.notes = notes
    }
}
