//
//  ContentViewModel.swift
//  iosApp
//
//  Created by Monokouma on 24/10/2025.
//

import Foundation
import Shared

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading = true
    
    private let isUserAuthUseCase: IsUserAuthUseCase
    
    init() {
        
        let koin = KoinHelper()
        self.isUserAuthUseCase = koin.isUserAuthUseCase()
    }
    
    func checkAuth() {
        Task {
            do {
                let result = try await isUserAuthUseCase.invoke()
                print(result.boolValue)
                isAuthenticated = result.boolValue
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.isLoading = false
                })
            } catch {
                isAuthenticated = false
                self.isLoading = false
            }
        }
    }
     
}
