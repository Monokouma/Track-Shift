import Foundation
import SwiftUI
import Shared
import AuthenticationServices
import MusicKit

@MainActor
class ResultsViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showSuccessAlert = false
    @Published var createdPlaylistUrl: String?
    @Published var isSpotifyAuthenticated = false
    
    
    private let getSpotifyAuthUrlUseCase: GetSpotifyAuthUrlUseCase
    private let handleSpotifyCallbackUseCase: HandleSpotifyCallbackUseCase
    private let isSpotifyAuthenticatedUseCase: IsSpotifyAuthenticatedUseCase
    private let createSpotifyPlaylistUseCase: CreateSpotifyPlaylistUseCase
    
    override init() {
        let koin = KoinHelper()
        self.getSpotifyAuthUrlUseCase = koin.getSpotifyAuthUrlUseCase()
        self.handleSpotifyCallbackUseCase = koin.handleSpotifyCallbackUseCase()
        self.isSpotifyAuthenticatedUseCase = koin.isSpotifyAuthenticatedUseCase()
        self.createSpotifyPlaylistUseCase = koin.createSpotifyPlaylistUseCase()
        
        super.init()
        
        isSpotifyAuthenticated = isSpotifyAuthenticatedUseCase.invoke()
    }
    
    
    
    func handleMainButtonTap(tracks: [ConvertedTrack], platform: MusicPlatform) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        switch platform {
        case .appleMusic:
            createAppleMusicPlaylist(tracks: tracks)
        case .spotify:
            handleSpotifyAction(tracks: tracks)
        case .deezer, .youtubeMusic:
            openPlatformApp(platform: platform)
        }
    }
    
    
    
    private func createAppleMusicPlaylist(tracks: [ConvertedTrack]) {
        isLoading = true
        
        Task {
            do {
                let playlistName = "TrackShift \(Date().formatted(date: .abbreviated, time: .omitted))"
                let playlist = try await AppleMusicService.shared.createPlaylist(
                    name: playlistName,
                    tracks: tracks
                )
                
                isLoading = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                AppleMusicService.shared.openPlaylist(playlist)
                
            } catch {
                handleError(error.localizedDescription)
            }
        }
    }
    
    
    
    private func handleSpotifyAction(tracks: [ConvertedTrack]) {
        if isSpotifyAuthenticated {
            createSpotifyPlaylist(tracks: tracks)
        } else {
            Task {
                await authenticateSpotify(tracks: tracks)
            }
        }
    }
    
    private func authenticateSpotify(tracks: [ConvertedTrack]) async {
        do {
        let authUrlString = try await getSpotifyAuthUrlUseCase.invoke()
        guard let authUrl = URL(string: authUrlString) else {
            handleError("URL d'authentification invalide")
            return
        }
        
        let code: String? = await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
            let session = ASWebAuthenticationSession(
                url: authUrl,
                callbackURLScheme: "trackshift"
            ) { callbackURL, error in
                guard error == nil,
                      let callbackURL = callbackURL,
                      let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                    .queryItems?
                    .first(where: { $0.name == "code" })?
                    .value
                else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: code)
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            session.start()
        }
        
        guard let code = code else { return }
        
            _ = try await handleSpotifyCallbackUseCase.invoke(code: code)
            isSpotifyAuthenticated = true
            
            createSpotifyPlaylist(tracks: tracks)
        } catch {
            handleError("Échec de l'authentification Spotify")
        }
    }
    
    private func createSpotifyPlaylist(tracks: [ConvertedTrack]) {
        isLoading = true
        print("🎵 Creating Spotify playlist with \(tracks.count) tracks")
        
        Task {
            do {
                let playlistName = "TrackShift \(Date().formatted(date: .abbreviated, time: .omitted))"
                let url = try await createSpotifyPlaylistUseCase.invoke(
                    name: playlistName,
                    tracks: tracks
                )
                
                isLoading = false
                
                if let urlString = url as String? {
                    print("✅ Playlist URL: \(urlString)")
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    
                    
                    if let spotifyUrl = URL(string: urlString.replacingOccurrences(of: "https://open.spotify.com/playlist/", with: "spotify:playlist:")),
                       UIApplication.shared.canOpenURL(spotifyUrl) {
                        await UIApplication.shared.open(spotifyUrl)
                    } else if let webUrl = URL(string: urlString) {
                        await UIApplication.shared.open(webUrl)
                    }
                } else {
                    handleError("Impossible de créer la playlist")
                }
                
            } catch {
                print("❌ Error: \(error)")
                handleError("Impossible de créer la playlist")
            }
        }
    }
    
    
    
    func openCreatedPlaylist() {
        guard let urlString = createdPlaylistUrl,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openPlatformApp(platform: MusicPlatform) {
        let urlString: String
        
        switch platform {
        case .spotify: urlString = "spotify://"
        case .deezer: urlString = "deezer://"
        case .youtubeMusic: urlString = "youtubemusic://"
        case .appleMusic: urlString = "music://"
        }
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func handleError(_ message: String) {
        isLoading = false
        errorMessage = message
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showError = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showError = false
            }
        }
    }
    
    
    
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? UIWindow()
        }
    }
}
