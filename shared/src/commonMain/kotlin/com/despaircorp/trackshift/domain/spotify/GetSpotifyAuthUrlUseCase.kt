package com.despaircorp.trackshift.domain.spotify

import com.despaircorp.trackshift.data.spotify.SpotifyRepository

class GetSpotifyAuthUrlUseCase(
    private val spotifyInterface: SpotifyInterface
) {
    suspend fun invoke(): String = spotifyInterface.getAuthUrl()
}