package com.despaircorp.trackshift.domain.spotify

import com.despaircorp.trackshift.data.spotify.SpotifyRepository

class HandleSpotifyCallbackUseCase(
    private val spotifyInterface: SpotifyInterface
) {
    suspend fun invoke(code: String): Result<Unit> = spotifyInterface.handleCallback(code)
}