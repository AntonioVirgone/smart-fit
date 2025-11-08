//
//  AddSetView.swift
//  SmartFit
//
//  Created by Antonio Virgone on 08/11/25.
//

import Foundation
import SwiftUI

struct AddSetView: View {
    // MARK: - Properties
    let exerciseName: String
    @Binding var reps: String
    @Binding var weight: String
    @Binding var notes: String
    @Binding var isPresented: Bool
    let onSave: () -> Void
    
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case reps, weight, notes
    }

    var body: some View {
        NavigationView{
            
        }
    }
}
