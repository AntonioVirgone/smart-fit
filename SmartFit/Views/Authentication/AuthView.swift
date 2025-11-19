//
//  AuthView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @State private var showRegister = false
    var body: some View {
        if showRegister {
            SignUpView(showRegister: $showRegister)
        } else {
            LoginView(showRegister: $showRegister)
        }
    }
}
