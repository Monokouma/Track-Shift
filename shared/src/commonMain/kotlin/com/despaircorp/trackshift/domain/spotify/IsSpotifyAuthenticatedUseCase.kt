package com.despaircorp.trackshift.domain.spotify

import com.despaircorp.trackshift.data.spotify.SpotifyRepository

class IsSpotifyAuthenticatedUseCase(
    private val spotifyInterface: SpotifyInterface
) {
    fun invoke(): Boolean = spotifyInterface.isAuthenticated()
}