//
//  LoginView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 19/11/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var apiService: UserApiService

    @Binding var showRegister: Bool

    @State private var onClickRequest = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        VStack {
            VStack {
                // MARK: - Logo
                logo.padding(.top, 20)
                
                // MARK: - TextEdit per inserire username e password
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                            TextField("Username", text: $username)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal)
                
                // MARK: - Separator
                separator(circleColor: Color.blue, isLoading: apiService.isLoading)
                    .padding(.vertical, 10)
                
                // MARK: - Login button
                loginButton
                    .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)   // 👈 Cornice sottile
            )
            .padding(20)

            Button(action: {
                showRegister = true   // 👈 Passa alla schermata di registrazione
            }) {
                Text("Registrati")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing], 35)

        }
    }
    
    private var loginButton: some View {
        VStack {
            Button(action: {
                self.onClickRequest = true
                apiService.signIn(user: User(username: username, password: password))
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)               // 🔥 margine dai bordi
            .disabled(apiService.isLoading)
            
            if let error = apiService.errorMessage {
                if apiService.isError {
                    Text("Errore: \(error)")
                        .foregroundColor(.red)
                }
            }
            
            if self.onClickRequest && !apiService.isLoading && !apiService.isError {
                Text("Login effettuato con successo!")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white)
            }
        }
    }
}
