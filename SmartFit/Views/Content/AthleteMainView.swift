//
//  AthleteMainView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI

struct AthleteMainView: View {
    @State private var showingMenu = false
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        ZStack {
            // MARK: - Fullscreen Background Gradient
            backgroundGradient
                .ignoresSafeArea()   // <--- IMPORTANTISSIMO
            
            VStack(spacing: 0) {

                
                // MARK: - Main Content & Tab Bar
                TabView {
                    HomeView(workoutPlan: workoutPlan)
                        .background(Color.clear)
                        .tabItem {
                            Label("Workout", systemImage: "dumbbell.fill")
                        }
                    
                    TestPostApiView()
                        .background(Color.clear)
                        .tabItem {
                            Label("Clienti", systemImage: "person.3.fill")
                        }
                    
                    TestApiConnectionView()
                        .background(Color.clear)
                        .tabItem {
                            Label("Dashboard", systemImage: "person.text.rectangle")
                        }
                    
                    HistoryView()
                        .background(Color.clear)
                        .tabItem {
                            Label("History", systemImage: "clock.fill")
                        }
                    
                    SettingsView()
                        .background(Color.clear)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                .tint(Color.blue)                     // colore icone selezionate
                .scrollContentBackground(.hidden)     // elimina sfondo bianco nelle List
            }
        }
    }
}
