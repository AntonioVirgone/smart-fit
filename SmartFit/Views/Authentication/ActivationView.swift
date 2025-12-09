//
//  ActiveCustomerView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI

struct ActivationView: View {
    @EnvironmentObject var vm: CustomerViewModel

    @State private var onClickRequest = false
    
    @State private var email: String = ""
    @State private var activaionCode: String = ""
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            VStack {
                // MARK: - Logo
                logo.padding(.top, 20)
                
                // MARK: - TextEdit per inserire username e password
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            TextField("Mail", text: $email)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "lock")
                            TextField("ActivationCode", text: $activaionCode)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal)
                
                // MARK: - Separator
                separator(circleColor: Color.blue, isLoading: vm.isLoading)
                    .padding(.vertical, 10)

                // MARK: pulsante di registrazione
                Button {
                    Task { await activateCustomer() }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Attiva account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .background(primryColor)
                .cornerRadius(12)
                .padding(.horizontal, 60)

            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)   // 👈 Cornice sottile
            )
            .padding(20)
        }
    }
    
    // MARK: - Signup Logic
    private func activateCustomer() async {
        vm.isLoading.toggle()
        
        guard !email.isEmpty,
              !activaionCode.isEmpty else {
            errorMessage = "Tutti i campi sono obbligatori."
            return
        }

        do {
            try await vm.activateCustomer(email: email, activationCode: activaionCode)
            UserDefaults.standard.set(true, forKey: "isActivated")
        } catch {
            errorMessage = "Errore durante la registrazione. Riprova."
            print("Signup error:", error)
        }
        
        vm.isLoading.toggle()
    }
}
