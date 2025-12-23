//
//  CustomerViewModel.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CustomerViewModel: ObservableObject {
    @Published var customer: Customer?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let api = ApiService()
    
    // ---- POST LOGIN CUSTOMER ----
    func loginCustomer(email: String, password: String) async throws {
        struct LoginCustomerRequest: Codable {
            let email: String
            let password: String
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let body = LoginCustomerRequest(email: email, password: password)
            customer = try await api.post("/customers/login", body: body)
        } catch {
            errorMessage = "Errore durante il login: \(error.localizedDescription)"
            throw error
        }
    }
    
    // ---- POST ACTIVATE CUSTOMER ----
    func activateCustomer(email: String, activationCode: String) async throws {
        struct ActivateCustomerRequest: Codable {
            let email: String
            let activationCode: String
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let body = ActivateCustomerRequest(email: email, activationCode: activationCode)
            customer = try await api.patch("/customers/activate", body: body)
        } catch {
            errorMessage = "Errore durante l'attivazione: \(error.localizedDescription)"
            throw error
        }
    }

}
