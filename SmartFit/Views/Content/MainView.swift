//
//  MainView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 05/12/25.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var currentView: AppView = .home // 👈 Stato corrente
    @State private var showingMenu = false

    let workoutPlan: WorkoutPlan
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Header con Logo
                HeaderView(showingMenu: $showingMenu)
                
                Spacer()
                
                // HomeView(workoutPlan: workoutPlan)
                // View Corrente basata sullo stato
                switch currentView {
                case .home:
                    HomeView(workoutPlan: workoutPlan)
                case .saveHistory:
                    TestPostApiView()
                case .getWorkputData:
                    TestApiConnectionView()
                case .settings:
                    SettingsView()
                case .history:
                    HistoryView()
                }
            }
            // 👈 MENU OVERLAY A LIVELLO DI ZSTACK - sopra tutto
            if showingMenu {
                MenuOverlayView(
                    showingMenu: $showingMenu,
                    currentView: $currentView // 👈 Passa il binding
                )
            }
        }
    }
}
