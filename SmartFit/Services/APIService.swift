//
//  APIService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 10/11/25.
//

import Foundation
internal import Combine

class APIService: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    @Published var rawJSON: String = "Nessun dato caricato"

    let basePath: String = "https://smart-fit-api.onrender.com/api"

}
