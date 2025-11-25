//
//  WelcomeView.swift
//  iosApp
//
//  Created by Monokouma on 26/10/2025.
//

import SwiftUI

struct WelcomeView: View {
    let size: CGFloat = 120
    @State private var isNavigating = false
    @State private var isVisible = false
    @State private var iconScale: CGFloat = 0.3
    @State private var iconRotation: Double = -180
    @State private var glowOpacity: Double = 0
    @State private var particlesOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var contentOpacity: Double = 0
    @Binding var path: NavigationPath
    @State private var rotationAngle: Double = 0

    
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
            
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.primaryPurple.opacity(0.1))
                    .frame(width: CGFloat.random(in: 30...80))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 15)
                    .opacity(particlesOpacity)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                
                ZStack {
                    
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.primaryPurple.opacity(0.4),
                                        Color.primaryPurple.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: size + CGFloat(index * 40))
                            .scaleEffect(glowOpacity)
                            .opacity(glowOpacity * 0.6)
                            .blur(radius: 20)
                    }
                    
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.primaryPurple.opacity(0.8),
                                    Color.primaryPurple.opacity(0.3),
                                    Color.clear,
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: size + 20)
                        .rotationEffect(.degrees(iconRotation))
                        .opacity(glowOpacity)
                    
                    
                    RoundedRectangle(cornerRadius: size * 0.24)
                        .fill(.primaryPurple.opacity(0.2))
                        .overlay {
                            Image(systemName: "music.note")
                                .font(.system(size: size * 0.6, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: .primaryPurple.opacity(0.5), radius: 20, y: 10)
                        .shadow(color: .backgroundColor3, radius: 12, y: 4)
                        .frame(width: size, height: size)
                        .scaleEffect(iconScale)
                        .rotation3DEffect(
                            .degrees(iconRotation * 0.1),
                            axis: (x: 1, y: 1, z: 0)
                        )
                }
                .padding(.bottom, 40)
                
                
                VStack(spacing: 16) {
                    Text("Convertissez vos playlists en un instant")
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Bold", size: 28))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Changez de plateforme sans perdre vos playlists. Spotify, Apple Music, Deezer... Convertissez en quelques taps.")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.textColor2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .offset(y: contentOffset)
                .opacity(contentOpacity)
                
                Spacer()
                Spacer()
                
                
                Button {
                    navigateToAuth()
                } label: {
                    HStack(spacing: 8) {
                        Text("Commencer")
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .buttonStyle(EnhancedRoundButtonStyle())
                .disabled(isNavigating)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .offset(y: contentOffset)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        
        withAnimation(.easeOut(duration: 1.5)) {
            particlesOpacity = 1.0
        }
        
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            iconScale = 1.0
            iconRotation = 0
        }
        
        
        withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
            glowOpacity = 1.0
        }
        
        
        withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
            contentOffset = 0
            contentOpacity = 1.0
            isVisible = true
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            startContinuousRotation()
        }
        
        
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
            .delay(1.0)
        ) {
            iconScale = 1.05
        }
    }
    
    private func startContinuousRotation() {
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
            iconRotation = 360
        }
    }
    
    private func navigateToAuth() {
        guard !isNavigating else { return }
        
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        isNavigating = true
        
        withAnimation(.easeInOut(duration: 0.5)) {
            contentOpacity = 0
            contentOffset = -30
            iconScale = 0.8
            glowOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            path.append("auth")
        }
    }
}

struct EnhancedRoundButtonStyle: ButtonStyle {
    var backgroundColor: Color = .primaryPurple
    var foregroundColor: Color = .textColor1
    var cornerRadius: CGFloat = 16
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Montserrat-SemiBold", size: 17))
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(configuration.isPressed ? 0 : 1)
                }
            )
            .shadow(color: backgroundColor.opacity(0.5), radius: 20, y: 10)
            .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct RoundButtonStyle: ButtonStyle {
    var backgroundColor: Color = .primaryPurple
    var foregroundColor: Color = .textColor1
    var cornerRadius: CGFloat = .infinity
    var borderColor: Color? = nil
    var borderWidth: CGFloat = 1
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                if let borderColor {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()

    WelcomeView(path: $path)
}
