//
//  AuthViewModel.swift
//  iosApp
//
//  Created by Monokouma on 31/10/2025.
//

import Foundation
import Shared
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    private let manageEmailPasswordAuthUseCase: ManageEmailPasswordAuthUseCase
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    init() {
       let koin = KoinHelper()
        self.manageEmailPasswordAuthUseCase = koin
            .manageEmailPasswordAuthUseCase()
    }
    
    
    func authWithEmailPassword(email: String, password: String) async -> Bool {
        do {
            let result = try await manageEmailPasswordAuthUseCase.invoke(
                mail: email,
                password: password
            )
            print(result.boolValue)
            return result.boolValue
        } catch {
            return false
        }
    }
}
 
