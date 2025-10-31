//
//  AuthView.swift
//  iosApp
//
//  Created by Monokouma on 26/10/2025.
//

import SwiftUI

struct AuthView: View {
    @Binding var path: NavigationPath
    @State private var isVisible = false
    let size: CGFloat = 120
    @State private var showMoreOptions = false
    @StateObject private var viewModel = AuthViewModel()
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.primaryPurple
                .ignoresSafeArea()
            LinearGradient(
                colors: [
                    .backgroundColor1.opacity(0.6),
                    .backgroundColor1,
                    .backgroundColor1,
                    .backgroundColor1,
                    .backgroundColor1
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            if isVisible {
                
                VStack {
                    
                    RoundedRectangle(cornerRadius: size * 0.24)
                        .fill(.primaryPurple.opacity(0.2))
                        .overlay {
                            Image(systemName: "music.note")
                                .font(.system(size: size * 0.6, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: .backgroundColor3, radius: 12, y: 4)
                        .frame(width: size, height: size)
                    
                    Text("Vos playlists, toutes vos plateformes")
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Bold", size: 28))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if showError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    AuthButton(provider: .google) {
                        authWith(authProvider: .google)
                    }
                    
                    AuthButton(provider: .apple) {
                        authWith(authProvider: .apple)
                    }
                    
                    AuthButton(provider: .meta) {
                        authWith(authProvider: .meta)
                    }
                    
                    AuthButton(provider: .guest) {
                        authWith(authProvider: .guest)
                    }
                    .padding(.vertical, 28)
                    
                    
                    VStack {
                        Button("Plus de moyens de connexion") {
                            showMoreOptions = true
                        }
                        .underline()
                        .foregroundStyle(.textColor2)
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat", size: 16))
                        .padding(8)
                        
                        HStack {
                            Text("Conditions d'utilisation")
                                .foregroundStyle(.textColor2)
                                .font(.custom("Montserrat", size: 12))
                                .padding(8)
                            
                            Text("Politique de confidentialité")
                                .foregroundStyle(.textColor2)
                                .font(.custom("Montserrat", size: 12))
                                .padding(8)
                        }
                    }
                    .padding(.top, 12)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.snappy(duration: 1)) {
                isVisible = true
            }
        }.sheet(isPresented: $showMoreOptions) {
            MoreAuthOptionsView { email, pass in
                
                Task {
                    let success = await  viewModel
                        .authWithEmailPassword(
                            email: email,
                            password: pass)
                    if success {
                        self.showMoreOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.path.append("tuto")
                        })
                        
                    } else {
                        self.showMoreOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            
                            self.errorMessage = "Erreur lors de la connexion"
                            self.showError = true
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.showError = false
                        })
                    }
                }
                
               
            }
        }
        .navigationTransition(.automatic)
    }
    
    func authWith(authProvider: AuthProvider) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        switch authProvider {
        case .google:
            print("google")
        case .apple:
            print("apple")
        case .meta:
            print("meta")
        case .guest:
            print("guest")
        }
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    
    AuthView(path: $path)
}
