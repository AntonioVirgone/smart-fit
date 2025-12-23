//
//  CustomerModel.swift
//  SmartFit
//
//  Created by Antonio Virgone on 06/12/25.
//

import Foundation
struct Customer: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let email: String?
}
