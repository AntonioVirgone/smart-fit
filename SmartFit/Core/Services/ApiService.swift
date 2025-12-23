//
//  ApiService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Combine
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case serverError(Int)
    case emptyResponse
    case decoding(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL non valido"
        case .serverError(let status):
            return "Errore server: codice \(status)"
        case .emptyResponse:
            return "Risposta vuota dal server"
        case .decoding(let message):
            return "Errore di decoding: \(message)"
        }
    }
}

@MainActor
class ApiService: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    @Published var rawJSON: String = "Nessun dato caricato"

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private var baseURL: URL {
        URL(string: ProcessInfo.processInfo.environment["SMARTFIT_API_BASE_URL"] ?? "https://4d5917111b11.ngrok-free.app/api")!
    }

    /// Compatibilità con i servizi esistenti che concatenano direttamente la stringa.
    var baseUrl: String { baseURL.absoluteString }

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: -------- GENERIC GET --------
    func get<T: Decodable>(_ path: String) async throws -> T {
        try await send(path: path, method: "GET")
    }

    // MARK: -------- GENERIC POST --------
    func post<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        let bodyData = try encoder.encode(body)
        return try await send(path: path, method: "POST", body: bodyData)
    }

    // MARK: -------- GENERIC PATCH --------
    func patch<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        let bodyData = try encoder.encode(body)
        return try await send(path: path, method: "PATCH", body: bodyData)
    }

    // MARK: -------- GENERIC DELETE --------
    func delete(_ path: String) async throws {
        _ = try await send(path: path, method: "DELETE") as EmptyResponse
    }

    // MARK: -------- PING SERVER --------
    func wakeServer() async {
        do {
            _ = try await send(path: "/health", method: "GET") as EmptyResponse
            print("🌐 Server Render svegliato!")
        } catch {
            print("⚠️ Ping fallito, ma continuo comunque:", error.localizedDescription)
        }
    }

    // MARK: - Core request executor
    private func send<T: Decodable>(path: String, method: String, body: Data? = nil) async throws -> T {
        let request = try makeRequest(path: path, method: method, body: body)
        let (data, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        if data.isEmpty {
            guard T.self == EmptyResponse.self else { throw NetworkError.emptyResponse }
            return EmptyResponse() as! T
        }

        do {
            if let raw = String(data: data, encoding: .utf8) {
                rawJSON = raw
            }
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error.localizedDescription)
        }
    }

    private func makeRequest(path: String, method: String, body: Data? = nil) throws -> URLRequest {
        let sanitizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        guard let url = URL(string: sanitizedPath, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 30

        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}

private struct EmptyResponse: Decodable {}
