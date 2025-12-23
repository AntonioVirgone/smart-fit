//
//  HistoryModels.swift
//  SmartFit
//
//  Created by Antonio Virgone on 12/11/25.
//

import Foundation
 
struct History: Codable {
    var jsonData: HistoryWorkoutData
    var filename: String
    var status: String
    
    init(jsonData: HistoryWorkoutData, filename: String, status: String) {
        self.jsonData = jsonData
        self.filename = filename
        self.status = status
    }
}

struct HistoryWorkoutData: Codable {
    var data: [String: [WorkoutSet]]
    
    init(data: [String: [WorkoutSet]]) {
        self.data = data
    }
}
