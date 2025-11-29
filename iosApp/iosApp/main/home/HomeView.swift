//
//  HomeView.swift
//  iosApp
//
//  Created by Monokouma on 16/11/2025.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = HomeViewModel()
    
    // Animation states
    @State private var headerOpacity: Double = 0
    @State private var headerOffset: CGFloat = -20
    @State private var carouselOpacity: Double = 0
    @State private var carouselScale: CGFloat = 0.95
    @State private var platformOpacity: Double = 0
    @State private var platformOffset: CGFloat = 30
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 40
    @State private var particlesOpacity: Double = 0
    
    // Positions fixes pour les particules
    private let particlePositions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = {
        (0..<10).map { _ in
            (
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height * 1.5),
                size: CGFloat.random(in: 40...120)
            )
        }
    }()
    
    var body: some View {
        ZStack {
            // Background
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
            
            // Particules flottantes
            ForEach(Array(particlePositions.enumerated()), id: \.offset) { index, particle in
                Circle()
                    .fill(Color.primaryPurple.opacity(0.06))
                    .frame(width: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .blur(radius: 25)
                    .opacity(particlesOpacity)
            }
            
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    HeaderView()
                        .offset(y: headerOffset)
                        .opacity(headerOpacity)
                    
                    // Upload Carousel
                    UploadScreenshotCarousel(
                        selectedImages: $viewModel.selectedImages,
                        imagesData: $viewModel.imagesData
                    )
                    .scaleEffect(carouselScale)
                    .opacity(carouselOpacity)
                    
                    // Platform Selection
                    VStack(spacing: 16) {
                        Text("Choisissez la plateforme de destination")
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .foregroundStyle(.textColor1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 24)
                        
                        PlatformSelectionGrid(
                            selectedPlatform: $viewModel.selectedPlatform
                        )
                    }
                    .offset(y: platformOffset)
                    .opacity(platformOpacity)
                    
                    // Convert Button
                    ConvertButton(
                        isEnabled: viewModel.canConvert,
                        isLoading: viewModel.isLoading
                    ) {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        Task {
                            await viewModel.convertPlaylist()
                        }
                    }
                    .offset(y: buttonOffset)
                    .opacity(buttonOpacity)
                    .padding(.bottom, 40)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            startAnimations()
        }.sheet(isPresented: $viewModel.showResults) {
            ResultsView(
                tracks: viewModel.convertedTracks,
                platform: viewModel.selectedPlatform ?? .appleMusic
            )
        }
    }
    
    private func startAnimations() {
        // Haptic
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Particules
        withAnimation(.easeOut(duration: 1.5)) {
            particlesOpacity = 1.0
        }
        
        // Header
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            headerOffset = 0
            headerOpacity = 1.0
        }
        
        // Carousel
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.15)) {
            carouselScale = 1.0
            carouselOpacity = 1.0
        }
        
        // Platform
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.3)) {
            platformOffset = 0
            platformOpacity = 1.0
        }
        
        // Button
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.45)) {
            buttonOffset = 0
            buttonOpacity = 1.0
        }
    }
}


struct HeaderView: View {
    @State private var iconScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 12) {
            // Icône animée
            ZStack {
                // Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.primaryPurple.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .blur(radius: 10)
                
                Image(systemName: "music.note.list")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(.primaryPurple)
                    .scaleEffect(iconScale)
            }
            .padding(.bottom, 8)
            
            Text("Convertissez votre playlist")
                .foregroundStyle(.textColor1)
                .font(.custom("Montserrat-Bold", size: 26))
                .multilineTextAlignment(.center)
            
            Text("Importez une ou plusieurs captures d'écran")
                .font(.custom("Montserrat", size: 16))
                .foregroundStyle(.textColor2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(0.5)
            ) {
                iconScale = 1.1
            }
        }
    }
}

struct UploadScreenshotCarousel: View {
    @Binding var selectedImages: [UIImage]
    @Binding var imagesData: [Data]
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var currentIndex: Int = 0
    @State private var uploadAreaScale: CGFloat = 1.0
    @State private var uploadIconOffset: CGFloat = 0
    
    private let maxImages = 5
    
    var body: some View {
        VStack(spacing: 16) {
            
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: maxImages,
                matching: .screenshots
            ) {
                if selectedImages.isEmpty {
                    // Empty state amélioré
                    VStack(spacing: 20) {
                        ZStack {
                            // Cercles de glow
                            ForEach(0..<2) { index in
                                Circle()
                                    .fill(Color.primaryPurple.opacity(0.1))
                                    .frame(width: 80 + CGFloat(index * 20))
                                    .blur(radius: 10)
                            }
                            
                            RoundedRectangle(cornerRadius: 16)
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
                                .frame(width: 72, height: 72)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.primaryPurple.opacity(0.3), lineWidth: 1.5)
                                )
                            
                            Image(systemName: "arrow.up.doc.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.primaryPurple)
                                .offset(y: uploadIconOffset)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Touchez pour importer")
                                .font(.custom("Montserrat-Bold", size: 18))
                                .foregroundColor(.textColor1)
                            
                            Text("Jusqu'à \(maxImages) screenshots")
                                .font(.custom("Montserrat", size: 14))
                                .foregroundColor(.textColor2)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Hint
                        HStack(spacing: 6) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 12))
                            Text("Appuyez ici")
                                .font(.custom("Montserrat-Medium", size: 12))
                        }
                        .foregroundColor(.primaryPurple.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.primaryPurple.opacity(0.1))
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 450)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .strokeBorder(
                                style: StrokeStyle(lineWidth: 2, dash: [10, 8])
                            )
                            .foregroundColor(.primaryPurple.opacity(0.3))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.primaryPurple.opacity(0.05),
                                        Color.primaryPurple.opacity(0.02)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .scaleEffect(uploadAreaScale)
                } else {
                    // Images carousel
                    ZStack {
                        TabView(selection: $currentIndex) {
                            ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .strokeBorder(Color.primaryPurple.opacity(0.3), lineWidth: 2)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
                                    .padding(.horizontal, 4)
                                    .tag(index)
                            }
                        }
                        .frame(height: 450)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        // Delete button
                        VStack {
                            HStack {
                                // Counter badge
                                Text("\(currentIndex + 1)/\(selectedImages.count)")
                                    .font(.custom("Montserrat-Bold", size: 13))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.black.opacity(0.6))
                                    )
                                    .padding(16)
                                
                                Spacer()
                                
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    deleteImage(at: currentIndex)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red.opacity(0.9))
                                            .frame(width: 40, height: 40)
                                            .shadow(color: .red.opacity(0.3), radius: 8, y: 4)
                                        
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(16)
                            }
                            Spacer()
                        }
                        
                        // Page indicators
                        VStack {
                            Spacer()
                            HStack(spacing: 8) {
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    Capsule()
                                        .fill(currentIndex == index ? Color.primaryPurple : Color.white.opacity(0.4))
                                        .frame(width: currentIndex == index ? 24 : 8, height: 8)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.4))
                            )
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .buttonStyle(CarouselButtonStyle())
            
            // Action buttons
            HStack(spacing: 12) {
                if !selectedImages.isEmpty {
                    if selectedImages.count < maxImages {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: maxImages,
                            matching: .screenshots
                        ) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 16))
                                Text("Ajouter")
                                    .font(.custom("Montserrat-SemiBold", size: 15))
                            }
                            .foregroundColor(.primaryPurple)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.primaryPurple.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.primaryPurple.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    
                    Button(action: {
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedImages.removeAll()
                            imagesData.removeAll()
                            selectedItems.removeAll()
                            currentIndex = 0
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 14))
                            Text("Tout supprimer")
                                .font(.custom("Montserrat-SemiBold", size: 15))
                        }
                        .foregroundColor(.red)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .onChange(of: selectedItems) { oldValue, newValue in
            Task {
                await loadImages(from: newValue)
            }
        }
        .onAppear {
            // Animation de l'icône upload
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                uploadIconOffset = -8
            }
        }
    }
    
    private func loadImages(from items: [PhotosPickerItem]) async {
        var newImages: [UIImage] = []
        var newData: [Data] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
                newData.append(data)
            }
        }
        
        await MainActor.run {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                selectedImages = newImages
                imagesData = newData
                currentIndex = 0
            }
        }
    }
    
    private func deleteImage(at index: Int) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            selectedImages.remove(at: index)
            imagesData.remove(at: index)
            
            if currentIndex >= selectedImages.count {
                currentIndex = max(0, selectedImages.count - 1)
            }
        }
    }
}


struct PlatformSelectionGrid: View {
    @Binding var selectedPlatform: MusicPlatform?
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 14),
                GridItem(.flexible(), spacing: 14)
            ],
            spacing: 14
        ) {
            ForEach(MusicPlatform.allCases, id: \.self) { platform in
                PlatformButton(
                    platform: platform,
                    isSelected: selectedPlatform == platform
                ) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedPlatform = platform
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}


struct PlatformButton: View {
    let platform: MusicPlatform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 14) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.primaryPurple.opacity(0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 35
                                )
                            )
                            .frame(width: 70, height: 70)
                            .blur(radius: 5)
                    }
                    
                    Image(platform.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                
                Text(platform.displayName)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(isSelected ? .textColor1 : .textColor2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected
                        ? LinearGradient(
                            colors: [
                                Color.primaryPurple.opacity(0.15),
                                Color.primaryPurple.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color.black.opacity(0.3), Color.black.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isSelected ? Color.primaryPurple : Color.textColor2.opacity(0.2),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            )
            .shadow(
                color: isSelected ? Color.primaryPurple.opacity(0.2) : Color.clear,
                radius: 12,
                y: 4
            )
            .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}


struct ConvertButton: View {
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void
    
    @State private var glowOpacity: Double = 0.5
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Glow animé
                if isEnabled && !isLoading {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.primaryPurple)
                        .blur(radius: 20)
                        .opacity(glowOpacity)
                        .offset(y: 5)
                }
                
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                        Text("Conversion en cours...")
                    } else {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Convertir ma playlist")
                    }
                }
                .font(.custom("Montserrat-Bold", size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            isEnabled
                            ? LinearGradient(
                                colors: [.primaryPurple, .primaryPurple.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [.textColor2.opacity(0.2), .textColor2.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            isEnabled ? Color.white.opacity(0.2) : Color.clear,
                            lineWidth: 1
                        )
                )
            }
        }
        .disabled(!isEnabled || isLoading)
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                glowOpacity = 0.8
            }
        }
    }
}


struct CarouselButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}


enum MusicPlatform: String, CaseIterable {
    case spotify = "spotify"
    case appleMusic = "appleMusic"
    case deezer = "deezer"
    case youtubeMusic = "youtubeMusic"
    
    var displayName: String {
        switch self {
        case .spotify: return "Spotify"
        case .appleMusic: return "Apple Music"
        case .deezer: return "Deezer"
        case .youtubeMusic: return "YouTube Music"
        }
    }
    
    var imageName: String {
        switch self {
        case .spotify: return "spotify"
        case .appleMusic: return "apple_music"
        case .deezer: return "deezer"
        case .youtubeMusic: return "youtube_music"
        }
    }
    
    var apiValue: String {
        switch self {
        case .spotify: return "spotify"
        case .appleMusic: return "apple_music"
        case .deezer: return "deezer"
        case .youtubeMusic: return "youtube_music"
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    HomeView(path: $path)
}
