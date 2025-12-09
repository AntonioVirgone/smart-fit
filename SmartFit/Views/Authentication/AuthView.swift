//
//  AuthView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var vm: CustomerViewModel   // <--- ORA È CONDIVISO

    var isActivated: Bool {
        return UserDefaults.standard.bool(forKey: "isActivated");
    }

    var body: some View {
        if isActivated {
            LoginView()
        } else {
            ActivationView()
        }
    }
}
