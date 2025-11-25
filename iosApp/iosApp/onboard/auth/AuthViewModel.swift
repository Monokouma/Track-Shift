//
//  AuthViewModel.swift
//  iosApp
//
//  Created by Monokouma on 31/10/2025.
//

import Foundation
import Shared
import SwiftUI
import AuthenticationServices
import CryptoKit
import GoogleSignIn

@MainActor
class AuthViewModel: NSObject, ObservableObject {
    private let manageEmailPasswordAuthUseCase: ManageEmailPasswordAuthUseCase
    private let manageAnonymousAuthUseCase: ManageAnonymousAuthUseCase
    private let manageAuthWithAppleUseCase: ManageAuthWithAppleUseCase
    private let manageAuthWithGoogleUseCase: ManageAuthWithGoogleUseCase
    
    @Published var googleAuthenticationSuccessful: Bool? = nil
    @State private var isLoading = false
    @State private var errorMessage = ""
    @Published var appleAuthenticationSuccessful: Bool? = nil
    
    private var currentNonce: String?

    override init() {
        let koin = KoinHelper()
        self.manageEmailPasswordAuthUseCase = koin
            .manageEmailPasswordAuthUseCase()
        
        self.manageAnonymousAuthUseCase = koin.manageAnonymousAuthUseCase()
        
        self.manageAuthWithAppleUseCase = koin.manageAuthWithAppleUseCase()
        self.manageAuthWithGoogleUseCase = koin.manageAuthWithGoogleUseCase()
        super.init()
    }
    
    func authAnonymously() async -> Bool {
        do {
           let result = try await manageAnonymousAuthUseCase.invoke()
            
            print(result.boolValue)
            return result.boolValue
        } catch {
            return false
        }
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
    
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("No root view controller found")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Google Sign In error: \(error.localizedDescription)")
                Task { @MainActor in
                    self.googleAuthenticationSuccessful = false
                }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Failed to get ID token")
                Task { @MainActor in
                    self.googleAuthenticationSuccessful = false
                }
                return
            }
            
            Task {
                do {
                    let result = try await self.manageAuthWithGoogleUseCase.invoke(idToken: idToken)
                    
                    await MainActor.run {
                        self.googleAuthenticationSuccessful = result.boolValue
                    }
                } catch {
                    print("Error calling use case: \(error)")
                    await MainActor.run {
                        self.googleAuthenticationSuccessful = false
                    }
                }
            }
        }
    }
    
}
 
extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data")
                return
            }
            
            Task {
                do {
                    let result = try await manageAuthWithAppleUseCase.invoke(
                        idToken: idTokenString,
                        nonce: nonce
                    )
                    await MainActor.run {
                        self.appleAuthenticationSuccessful = result.boolValue
                    }
                    print("Sign in result: \(result.boolValue)")
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}
