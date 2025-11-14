//
//  MenuView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 13/11/25.
//

import Foundation
import SwiftUI

// Aggiungi questo enum sopra MenuOverlayView
enum AppView {
    case home
    case saveHistory
    case getWorkputData
    case settings
}

// MARK: - Menu Overlay
struct MenuOverlayView: View {
    @Binding var showingMenu: Bool
    @Binding var currentView: AppView // 👈 Nuovo binding

    var body: some View {
        ZStack {
            // Sfondo semi-trasparente che copre TUTTO lo schermo
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingMenu = false
                    }
                }
            
            // Contenuto del menu
            VStack(alignment: .leading, spacing: 0) {
                // Spazio per il safe area
                Color.clear
                    .frame(height: 60)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header Menu
                    HStack {
                        Text("Menu")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingMenu = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    // Voci Menu
                    LazyVStack(spacing: 0) {
                        MenuRow(
                            icon: "person.circle.fill",
                            title: "Profilo",
                            color: .blue,
                            action: {
                                withAnimation {
                                    currentView = .home
                                    showingMenu = false
                                }
                            }
                        )
                        
                        MenuRow(
                            icon: "chart.bar.fill",
                            title: "Statistiche Avanzate",
                            color: .green,
                            action: {
                                withAnimation {
                                    showingMenu = false
                                }
                            }
                        )
                        
                        MenuRow(
                            icon: "clock.arrow.circlepath",
                            title: "Carica Workout Data",
                            color: .orange,
                            action: {
                                withAnimation {
                                    currentView = .getWorkputData
                                    showingMenu = false
                                }
                            }
                        )
                        
                        MenuRow(
                            icon: "heart.circle.fill",
                            title: "Salva History",
                            color: .red,
                            action: {
                                withAnimation {
                                    currentView = .saveHistory
                                    showingMenu = false
                                }
                            }
                        )
                        
                        MenuRow(
                            icon: "gearshape.fill",
                            title: "Impostazioni",
                            color: .gray,
                            action: {
                                withAnimation {
                                    currentView = .settings
                                    showingMenu = false
                                }
                                // Naviga alle impostazioni
                            }
                        )
                    }
                    
                    // Footer Menu
                    VStack(spacing: 12) {
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        HStack {
                            Text("GymBro v1.0")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Spacer()
                            
                            Text("by Il Tuo Nome")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.17, blue: 0.23),
                            Color(red: 0.11, green: 0.13, blue: 0.19)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .zIndex(1000) // 👈 ASSICURA che il menu sia sopra tutto
    }
}

// MARK: - Componente Riga Menu
struct MenuRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Feedback aptico
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(isPressed ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 50, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
