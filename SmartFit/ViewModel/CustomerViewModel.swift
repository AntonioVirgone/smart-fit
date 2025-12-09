//
//  CustomerViewModel.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class CustomerViewModel: ObservableObject {
    @Published var customer: Customer?
    @Published var isLoading: Bool = false

    private let api = ApiService()
    
    // ---- POST LOGIN CUSTOMER ----
    func loginCustomer(email: String, password: String) async throws {
        struct LoginCustomerRequest: Codable {
            let email: String
            let password: String
        }

        do {
            let body = LoginCustomerRequest(email: email, password: password)
            
            let loginCustomer: Customer = try await api.post("/customers/login", body: body)
            
            print(loginCustomer)
            
            customer = loginCustomer
        } catch {
            print("Errore [POST] loginCustomer: ", error)
            throw error   // 🔥 RILANCIA L’ERRORE QUI
        }
    }
    
    // ---- POST ACTIVATE CUSTOMER ----
    func activateCustomer(email: String, activationCode: String) async throws {
        struct ActivateCustomerRequest: Codable {
            let email: String
            let activationCode: String
        }

        do {
            let body = ActivateCustomerRequest(email: email, activationCode: activationCode)
            
            let activatedCustomer: Customer = try await api.patch("/customers/activate", body: body)
            
            print(activatedCustomer)
            
            customer = activatedCustomer
        } catch {
            print("Errore [POST] activateCustomer: ", error)
            throw error   // 🔥 RILANCIA L’ERRORE QUI
        }
    }

}
