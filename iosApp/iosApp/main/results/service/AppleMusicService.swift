//
//  AppleMusicService.swift
//  iosApp
//
//  Created by Monokouma on 27/11/2025.
//

import Foundation
import Shared
import MusicKit
import UIKit

class AppleMusicService {
    static let shared = AppleMusicService()
    
    private init() {}
    
    // MARK: - Authorization
    
    func requestAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }
    
    // MARK: - Create Playlist
    
    func createPlaylist(name: String, tracks: [ConvertedTrack]) async throws -> Playlist {
        guard await requestAuthorization() else {
            throw AppleMusicError.notAuthorized
        }
        
        var songs: [Song] = []
        
        for track in tracks {
            do {
                if let song = try await searchSong(title: track.title, artist: track.artist) {
                    songs.append(song)
                }
            } catch {
                print("Musique non trouvée: \(track.title) - \(track.artist)")
            }
        }
        
        guard !songs.isEmpty else {
            throw AppleMusicError.noTracksFound
        }
        
        let playlist = try await MusicLibrary.shared.createPlaylist(
            name: name,
            description: "Créée avec TrackShift 🎵",
            items: songs
        )
        
        return playlist
    }
    
    // MARK: - Search
    
    private func searchSong(title: String, artist: String) async throws -> Song? {
        var request = MusicCatalogSearchRequest(term: "\(title) \(artist)", types: [Song.self])
        request.limit = 1
        
        let response = try await request.response()
        return response.songs.first
    }
    
    // MARK: - Open Playlist
    
    func openPlaylist(_ playlist: Playlist) {
        guard let url = playlist.url else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Errors

enum AppleMusicError: LocalizedError {
    case notAuthorized
    case noTracksFound
    case playlistCreationFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Accès à Apple Music refusé"
        case .noTracksFound:
            return "Aucun titre trouvé sur Apple Music"
        case .playlistCreationFailed:
            return "Impossible de créer la playlist"
        }
    }
}
