//
//  ContentView.swift
//  iosApp
//
//  Created by Monokouma on 22/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(1)
            } else if viewModel.isAuthenticated {
                MainNavigationView()
                    .transition(.opacity)
            } else {
                OnBoardingView(onAuthComplete: {
                    
                    viewModel.isAuthenticated = true
                })
                .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.checkAuth()
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: viewModel.isAuthenticated)
    }
}

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var glowOpacity: Double = 0
    @State private var particlesOpacity: Double = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color.black,
                    Color(red: 0.1, green: 0.05, blue: 0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: CGFloat.random(in: 50...150))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 20)
                    .opacity(particlesOpacity)
            }
            
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 200 + CGFloat(index * 60))
                        .scaleEffect(glowOpacity)
                        .opacity(glowOpacity * 0.5)
                        .blur(radius: 10)
                }
            }
            .rotationEffect(.degrees(rotation))
            
            ZStack {
                Image("app_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .blur(radius: 30)
                    .opacity(glowOpacity * 0.8)
                
                Image("app_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(26)
                    .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
                    .shadow(color: .purple.opacity(0.3), radius: 40, x: 0, y: 20)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
            
            VStack {
                Spacer()
                Image("app_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(26)
                    .opacity(0.15)
                    .blur(radius: 5)
                    .scaleEffect(y: -1)
                    .offset(y: -80)
                    .mask(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.3), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(logoOpacity * 0.5)
                Spacer()
            }
        }
        .onAppear {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeOut(duration: 0.8)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                glowOpacity = 1.0
                particlesOpacity = 1.0
            }
            
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(0.8)
            ) {
                logoScale = 1.05
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
