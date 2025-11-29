//
//  ResultsView.swift
//  iosApp
//
//  Created by Monokouma on 27/11/2025.
//

import SwiftUI
import Shared
import MusicKit

struct ResultsView: View {
    let tracks: [ConvertedTrack]
    let platform: MusicPlatform
    
    @StateObject private var viewModel = ResultsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var headerOpacity: Double = 0
    @State private var headerOffset: CGFloat = -20
    @State private var tracksVisible: Bool = false
    @State private var buttonVisible: Bool = false
    @State private var particlesOpacity: Double = 0
    

    private let particlePositions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = {
        (0..<10).map { _ in
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
                    .backgroundColor1
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            ForEach(Array(particlePositions.enumerated()), id: \.offset) { index, particle in
                Circle()
                    .fill(Color.primaryPurple.opacity(0.06))
                    .frame(width: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .blur(radius: 20)
                    .opacity(particlesOpacity)
            }
            
            
            VStack(spacing: 0) {
                
                ResultsHeaderView(
                    tracksCount: tracks.count,
                    platform: platform,
                    onClose: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    }
                )
                .offset(y: headerOffset)
                .opacity(headerOpacity)
                
                
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                            TrackRowView(track: track, index: index)
                                .opacity(tracksVisible ? 1 : 0)
                                .offset(y: tracksVisible ? 0 : 20)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.75)
                                    .delay(Double(index) * 0.06),
                                    value: tracksVisible
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            
            
            if viewModel.showError {
                VStack {
                    ErrorToast(message: viewModel.errorMessage) {
                        withAnimation {
                            viewModel.showError = false
                        }
                    }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
        }
        .overlay(alignment: .bottom) {
            OpenAllButton(
                platform: platform,
                isLoading: viewModel.isLoading
            ) {
                viewModel.handleMainButtonTap(tracks: tracks, platform: platform)
            }
            .offset(y: buttonVisible ? 0 : 100)
            .opacity(buttonVisible ? 1 : 0)
        }
        .alert("Playlist créée !", isPresented: $viewModel.showSuccessAlert) {
            Button("Ouvrir") {
                viewModel.openCreatedPlaylist()
            }
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        withAnimation(.easeOut(duration: 1.2)) {
            particlesOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            headerOffset = 0
            headerOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            tracksVisible = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
            buttonVisible = true
        }
    }
}


struct ErrorToast: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
                .font(.system(size: 18))
            
            Text(message)
                .font(.custom("Montserrat-Medium", size: 14))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.red)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }
}

struct ResultsHeaderView: View {
    let tracksCount: Int
    let platform: MusicPlatform
    let onClose: () -> Void
    
    @State private var checkmarkScale: CGFloat = 0
    @State private var checkmarkOpacity: Double = 0
    @State private var glowScale: CGFloat = 0.5
    @State private var glowOpacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.textColor1)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(Color.textColor2.opacity(0.1))
                        )
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(platform.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    
                    Text(platform.displayName)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundStyle(.textColor1)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.primaryPurple.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(Color.primaryPurple.opacity(0.3), lineWidth: 1)
                        )
                )
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            
            VStack(spacing: 14) {
                ZStack {
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.green.opacity(0.4),
                                    Color.green.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(glowScale)
                        .opacity(glowOpacity)
                        .blur(radius: 10)
                    
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.green)
                        .scaleEffect(checkmarkScale * pulseScale)
                        .opacity(checkmarkOpacity)
                        .shadow(color: .green.opacity(0.3), radius: 10, y: 4)
                }
                
                Text("Conversion réussie !")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundStyle(.textColor1)
                
                HStack(spacing: 6) {
                    Text("\(tracksCount)")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundStyle(.primaryPurple)
                    
                    Text("titres trouvés")
                        .font(.custom("Montserrat-Medium", size: 16))
                        .foregroundStyle(.textColor2)
                }
            }
            .padding(.bottom, 12)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                checkmarkScale = 1.0
                checkmarkOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                glowScale = 1.0
                glowOpacity = 1.0
            }
            
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(0.8)
            ) {
                pulseScale = 1.08
            }
        }
    }
}

struct TrackRowView: View {
    let track: ConvertedTrack
    let index: Int
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            openTrack()
        } label: {
            HStack(spacing: 14) {
                Text("\(index + 1)")
                    .font(.custom("Montserrat-Bold", size: 14))
                    .foregroundStyle(.textColor2.opacity(0.6))
                    .frame(width: 24)
                
                AsyncImage(url: URL(string: track.thumbnailUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        thumbnailPlaceholder
                    case .empty:
                        thumbnailPlaceholder
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryPurple))
                                    .scaleEffect(0.6)
                            )
                    @unknown default:
                        thumbnailPlaceholder
                    }
                }
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.custom("Montserrat-SemiBold", size: 15))
                        .foregroundStyle(.textColor1)
                        .lineLimit(1)
                    
                    Text(track.artist)
                        .font(.custom("Montserrat-Medium", size: 13))
                        .foregroundStyle(.textColor2)
                        .lineLimit(1)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.primaryPurple.opacity(0.1))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primaryPurple)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.textColor1.opacity(0.04),
                                Color.textColor1.opacity(0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.textColor2.opacity(0.08), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(TrackButtonStyle())
    }
    
    private var thumbnailPlaceholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(
                    colors: [
                        Color.primaryPurple.opacity(0.2),
                        Color.primaryPurple.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Image(systemName: "music.note")
                    .font(.system(size: 18))
                    .foregroundStyle(.primaryPurple.opacity(0.5))
            }
    }
    
    private func openTrack() {
        guard let webUrl = URL(string: track.url) else { return }
        
        if let appUrl = getAppUrl(from: track.url),
           UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl)
        } else {
            UIApplication.shared.open(webUrl)
        }
    }
    
    private func getAppUrl(from urlString: String) -> URL? {
        if urlString.contains("music.apple.com") {
            return URL(string: urlString.replacingOccurrences(of: "https://", with: "music://"))
        }
        if urlString.contains("spotify.com"),
           let url = URL(string: urlString),
           let trackIndex = url.pathComponents.firstIndex(of: "track"),
           trackIndex + 1 < url.pathComponents.count {
            return URL(string: "spotify:track:\(url.pathComponents[trackIndex + 1])")
        }
        if urlString.contains("deezer.com") {
            return URL(string: urlString.replacingOccurrences(of: "https://www.deezer.com", with: "deezer://"))
        }
        if urlString.contains("music.youtube.com") {
            return URL(string: urlString.replacingOccurrences(of: "https://music.youtube.com", with: "youtubemusic://"))
        }
        return nil
    }
}

struct TrackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct OpenAllButton: View {
    let platform: MusicPlatform
    let isLoading: Bool
    let action: () -> Void
    
    @State private var glowOpacity: Double = 0.4
    
    private var buttonText: String {
        if isLoading {
            return "Création..."
        }
        switch platform {
        case .appleMusic, .spotify:
            return "Créer la playlist"
        default:
            return "Ouvrir \(platform.displayName)"
        }
    }
    
    private var buttonIcon: String {
        switch platform {
        case .appleMusic, .spotify:
            return "plus.circle.fill"
        default:
            return "arrow.up.right"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [
                    Color.backgroundColor1.opacity(0),
                    Color.backgroundColor1
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 30)
            .allowsHitTesting(false)
            
            VStack {
                Button(action: action) {
                    HStack(spacing: 10) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(platform.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        
                        Text(buttonText)
                            .font(.custom("Montserrat-Bold", size: 16))
                        
                        if !isLoading {
                            Image(systemName: buttonIcon)
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.primaryPurple)
                                .blur(radius: 20)
                                .opacity(glowOpacity)
                                .offset(y: 4)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    LinearGradient(
                                        colors: [.primaryPurple, .primaryPurple.opacity(0.85)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(isLoading)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .background(Color.backgroundColor1)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowOpacity = 0.7
            }
        }
    }
}

#Preview {
    ResultsView(
        tracks: [
            ConvertedTrack(
                title: "Blinding Lights",
                artist: "The Weeknd",
                url: "https://music.apple.com/track/1",
                thumbnailUrl: "https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36",
                platformId: "1"
            ),
            ConvertedTrack(
                title: "Starboy",
                artist: "The Weeknd, Daft Punk",
                url: "https://music.apple.com/track/2",
                thumbnailUrl: "https://i.scdn.co/image/ab67616d0000b273a048415db06a5b6fa7ec4e1a",
                platformId: "2"
            ),
            ConvertedTrack(
                title: "Save Your Tears",
                artist: "The Weeknd",
                url: "https://music.apple.com/track/3",
                thumbnailUrl: "https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36",
                platformId: "3"
            )
        ],
        platform: .spotify
    )
}
