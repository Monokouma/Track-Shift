package com.despaircorp.trackshift.domain.spotify

import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack


class CreateSpotifyPlaylistUseCase(
    private val spotifyInterface: SpotifyInterface
) {
    suspend fun invoke(name: String, tracks: List<ConvertedTrack>): String? {
        val trackIds = tracks.map { it.platformId }
        return spotifyInterface.createPlaylistWithTracks(name, trackIds).getOrNull()
    }
}