//
//  MainTabView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

// Sostituisci il placeholder MainTabView con questa versione completa:
struct MainTabView: View {
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        TabView {
            // Tab Allenamento
            //WorkoutDaysListView(workoutPlan: workoutPlan)
            NewHomeView(workoutPlan: workoutPlan)
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Allenamento")
                }
            
            // Tab Progressi
            TestApiConnectionView()
                .tabItem {
                    Image(systemName: "circle.hexagonpath")
                    Text("Progressi")
                }
            
            TestPostApiView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save History")
                }
            
            // Tab Impostazioni
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Impostazioni")
                }
        }
    }
}
