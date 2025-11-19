//
//  AuthView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @StateObject private var apiService = UserApiService()
    
    @State private var onClickRequest = false

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var newMail: String = ""

    // @FocusState private var focusedField: Field?

    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        VStack {
            // MARK: - Logo
            logo

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
            
            // MARK: - Login button
            loginButton

            // MARK: - Separator
            separator
                .padding(.vertical, 10)

            // MARK: - Create new account
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Username", text: $newUsername)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    HStack {
                        Image(systemName: "envelope.fill")
                        TextField("Mail", text: $newMail)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    HStack {
                        Image(systemName: "lock")
                        SecureField("Password", text: $newPassword)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal)
            
            // MARK: Create new account
            signupButton
        }
    }
    
    private var logo: some View {
        VStack {
            // Logo o icona dell'app
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            // Nome dell'app
            Text("SmartFit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
        }
        .scaleEffect(size)
        .opacity(opacity)
        /*
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.size = 1.0
                self.opacity = 1.0
            }
        }
         */
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
            
            if apiService.isLoading {
                ProgressView("Invio dati...")
            }
            
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
    
    private var signupButton: some View {
        VStack {
            Button(action: {
                self.onClickRequest = true
                apiService.signUp(user: User(username: username, password: password, email: newMail))
            }) {
                Text("Create new account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)               // 🔥 margine dai bordi
            .disabled(apiService.isLoading)
            
            if apiService.isLoading {
                ProgressView("Invio dati...")
            }
            
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
    
    private var separator: some View {
        HStack {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray)

            Circle()
                .frame(width: 14, height: 14)
                .foregroundColor(.blue)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
    }
}
