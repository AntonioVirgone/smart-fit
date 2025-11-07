//
//  ErrorView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 07/11/25.
//

import Foundation
import SwiftUI

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                
                Text("Ops!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Button("Riprova", action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding(40)
        }
    }
}
