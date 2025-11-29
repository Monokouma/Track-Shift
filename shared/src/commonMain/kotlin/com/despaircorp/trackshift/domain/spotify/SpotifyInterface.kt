package com.despaircorp.trackshift.domain.spotify

interface SpotifyInterface {
    suspend fun getAuthUrl(): String
    fun isAuthenticated(): Boolean
    suspend fun handleCallback(code: String): Result<Unit>
    suspend fun createPlaylistWithTracks(name: String, trackIds: List<String>): Result<String>
}