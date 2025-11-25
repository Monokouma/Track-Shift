//
//  AuthView.swift
//  iosApp
//
//  Created by Monokouma on 26/10/2025.
//

import SwiftUI
import Combine

struct AuthView: View {
    @Binding var path: NavigationPath
    let onAuthComplete: () -> Void
    
    let size: CGFloat = 100
    @State private var showMoreOptions = false
    @State private var showPoliticsWebview = false
    @State private var showCGUWebview = false
    
    @StateObject private var viewModel = AuthViewModel()
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    
    
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30
    @State private var titleOpacity: Double = 0
    @State private var buttonsOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 40
    @State private var glowOpacity: Double = 0
    @State private var particlesOpacity: Double = 0
    
    
    private let particlePositions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = {
        (0..<12).map { _ in
            (
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 40...100)
            )
        }
    }()
    
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
            
            
            ForEach(Array(particlePositions.enumerated()), id: \.offset) { index, particle in
                Circle()
                    .fill(Color.primaryPurple.opacity(0.08))
                    .frame(width: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .blur(radius: 20)
                    .opacity(particlesOpacity)
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 60)
                    
                    ZStack {
                        
                        ForEach(0..<2) { index in
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.primaryPurple.opacity(0.3),
                                            Color.primaryPurple.opacity(0.1),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: size + CGFloat(index * 30))
                                .scaleEffect(glowOpacity)
                                .opacity(glowOpacity * 0.5)
                                .blur(radius: 15)
                        }
                        
                        
                        RoundedRectangle(cornerRadius: size * 0.24)
                            .fill(.primaryPurple.opacity(0.2))
                            .overlay {
                                Image(systemName: "music.note")
                                    .font(.system(size: size * 0.6, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .shadow(color: .primaryPurple.opacity(0.4), radius: 15, y: 8)
                            .shadow(color: .backgroundColor3, radius: 8, y: 3)
                            .frame(width: size, height: size)
                    }
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                    
                    
                    Text("Vos playlists,\ntoutes vos plateformes")
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Bold", size: 26))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)
                    
                    
                    if showError {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                                .font(.system(size: 16))
                            
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .font(.custom("Montserrat-Medium", size: 14))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .transition(.scale.combined(with: .opacity))
                        .padding(.horizontal, 32)
                    }
                    
                    VStack(spacing: 12) {
                        AuthButton(provider: .apple) {
                            authWith(authProvider: .apple)
                        }
                        
                        AuthButton(provider: .google) {
                            authWith(authProvider: .google)
                        }
                        
                        AuthButton(provider: .meta) {
                            authWith(authProvider: .meta)
                        }
                        
                        AuthButton(provider: .guest) {
                            authWith(authProvider: .guest)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    .offset(y: buttonsOffset)
                    .opacity(buttonsOpacity)
                    
                    VStack(spacing: 16) {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showMoreOptions = true
                        } label: {
                            Text("Plus de moyens de connexion")
                                .foregroundStyle(.textColor2)
                                .font(.custom("Montserrat-SemiBold", size: 15))
                                .underline()
                        }
                        
                        HStack(spacing: 20) {
                            Text("Conditions d'utilisation")
                                .foregroundStyle(.textColor2.opacity(0.7))
                                .font(.custom("Montserrat", size: 11))
                                .onTapGesture {
                                    showCGUWebview = true
                                }
                            
                            Text("•")
                                .foregroundStyle(.textColor2.opacity(0.5))
                            
                            Text("Politique de confidentialité")
                                .foregroundStyle(.textColor2.opacity(0.7))
                                .font(.custom("Montserrat", size: 11))
                                .onTapGesture {
                                    showPoliticsWebview = true
                                }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showMoreOptions) {
            MoreAuthOptionsView { email, pass in
                handleMailPasswordAuthResponse(email: email, password: pass)
            }
        }
        .sheet(isPresented: $showPoliticsWebview) {
            WebViewScreen(url: "https://trackshift.fr/politics", title: "Politics")
        }
        .sheet(isPresented: $showCGUWebview) {
            WebViewScreen(url: "https://trackshift.fr/cgu", title: "GTC")
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        withAnimation(.easeOut(duration: 1.2)) {
            particlesOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
            iconScale = 1.0
            iconOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            glowOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
            titleOffset = 0
            titleOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.5)) {
            buttonsOffset = 0
            buttonsOpacity = 1.0
        }
        
        withAnimation(
            .easeInOut(duration: 2.5)
            .repeatForever(autoreverses: true)
            .delay(1.0)
        ) {
            iconScale = 1.05
        }
    }
    
    func handleMailPasswordAuthResponse(email: String, password: String) {
        Task {
            let success = await viewModel.authWithEmailPassword(
                email: email,
                password: password
            )
            if success {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                self.showMoreOptions = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onAuthComplete()
                }
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                self.showMoreOptions = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        self.errorMessage = "Erreur lors de la connexion"
                        self.showError = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.showError = false
                    }
                }
            }
        }
    }
    
    func handleAnonymousAuthResponse() {
        Task {
            let success = await viewModel.authAnonymously()
            
            if success {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onAuthComplete() // 🎯
                }
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        self.errorMessage = "Erreur lors de la connexion"
                        self.showError = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.showError = false
                    }
                }
            }
        }
    }
    
    func handleAppleAuthResponse() {
        viewModel.signInWithApple()
        viewModel.$appleAuthenticationSuccessful
            .sink { value in
                if let value = value {
                    if value {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onAuthComplete() // 🎯
                        }
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                self.errorMessage = "Erreur lors de la connexion"
                                self.showError = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                self.showError = false
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func handleGoogleAuthResponse() {
        viewModel.signInWithGoogle()
        viewModel.$googleAuthenticationSuccessful
            .sink { value in
                if let value = value {
                    if value {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onAuthComplete() // 🎯
                        }
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                self.errorMessage = "Erreur lors de la connexion"
                                self.showError = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                self.showError = false
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func authWith(authProvider: AuthProvider) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        switch authProvider {
        case .google:
            handleGoogleAuthResponse()
        case .apple:
            handleAppleAuthResponse()
        case .meta:
            break
        case .guest:
            handleAnonymousAuthResponse()
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    AuthView(path: $path, onAuthComplete: {
        print("Auth complete!")
    })
}
