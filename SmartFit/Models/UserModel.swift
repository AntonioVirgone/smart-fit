//
//  UesrModel.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
    var email: String?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}
