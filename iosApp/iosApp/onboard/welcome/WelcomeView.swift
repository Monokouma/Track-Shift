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
    @Binding var path: NavigationPath

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
            
            VStack {
                Spacer()
                if isVisible {
                    RoundedRectangle(cornerRadius: size * 0.24)
                        .fill(.primaryPurple.opacity(0.2))
                        .overlay {
                            Image(systemName: "music.note")
                                .font(.system(size: size * 0.6, weight: .medium))
                                .foregroundStyle(.white)
                        }.shadow(color: .backgroundColor3, radius: 12, y: 4)
                        .frame(width: size, height: size)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    Text("Convertissez vos playlists en un instant")
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Bold", size: 28))
                        .multilineTextAlignment(.center)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    Text("Changez de plateforme sans perdre vos playlists. Spotify, Apple Music, Deezer... Convertissez en quelques taps.")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.textColor2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        
                        navigateToAuth()
                       
                    } label: {
                        Text("Commencer")
                    }.buttonStyle(RoundButtonStyle()).disabled(isNavigating) .padding().transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
        }.onAppear {
            withAnimation(.snappy(duration: 1)) {
                isVisible = true
            }
        }
    }
    
    private func navigateToAuth() {
        guard !isNavigating else { return }
        
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        isNavigating = true
        
        withAnimation(.snappy(duration: 1)) {
            isVisible = false
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            path.append("auth")
        }
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
            .animation(.spring(response: 0.4), value: configuration.isPressed)
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()

    WelcomeView(path: $path)
}
