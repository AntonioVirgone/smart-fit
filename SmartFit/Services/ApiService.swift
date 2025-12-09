//
//  ApiService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
internal import Combine

class ApiService: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    @Published var rawJSON: String = "Nessun dato caricato"

    //    private let baseUrl = "https://smart-fit-api.onrender.com/api"
    let baseUrl = "https://4d5917111b11.ngrok-free.app/api"

    // MARK: -------- GENERIC GET --------
    func get<T: Decodable>(_ path: String) async throws -> T {
        let url = URL(string: "\(baseUrl)\(path)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: -------- GENERIC POST --------
    func post<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        let url = URL(string: "\(baseUrl)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("RAW RESPONSE: ", String(data: data, encoding: .utf8)!)

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: -------- GENERIC PATCH --------
    func patch<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        let url = URL(string: "\(baseUrl)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: -------- GENERIC DELETE --------
    func delete(_ path: String) async throws {
        let url = URL(string: "\(baseUrl)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: -------- PING SERVER --------
    func wakeServer() async {
        let url = URL(string: "\(baseUrl)/health")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5  // Render potrebbe essere lento appena sveglio

        do {
            let _ = try await URLSession.shared.data(for: request)
            print("🌐 Server Render svegliato!")
        } catch {
            print("⚠️ Ping fallito, ma continuo comunque:", error.localizedDescription)
        }
    }
}
