package com.despaircorp.trackshift.data.spotify

import com.despaircorp.trackshift.domain.spotify.SpotifyInterface
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext

class SpotifyRepository(
    private val spotifyApi: SpotifyApi
): SpotifyInterface {
    override suspend fun getAuthUrl(): String = withContext(Dispatchers.IO) {
        spotifyApi.getAuthUrl()
    }

    override fun isAuthenticated(): Boolean = spotifyApi.isAuthenticated()

    override suspend fun handleCallback(code: String): Result<Unit> = withContext(Dispatchers.IO) {
        spotifyApi.exchangeCodeForToken(code).map { }
    }

    override suspend fun createPlaylistWithTracks(
        name: String,
        trackIds: List<String>
    ): Result<String> = withContext(Dispatchers.IO) {
        try {
            val userResult = spotifyApi.getCurrentUser()
            if (userResult.isFailure) {
                return@withContext Result.failure(userResult.exceptionOrNull()!!)
            }
            val userId = userResult.getOrThrow().id

            val playlistResult = spotifyApi.createPlaylist(userId, name)
            if (playlistResult.isFailure) {
                return@withContext Result.failure(playlistResult.exceptionOrNull()!!)
            }
            val playlist = playlistResult.getOrThrow()

            val trackUris = trackIds.map { "spotify:track:$it" }

            val addResult = spotifyApi.addTracksToPlaylist(playlist.id, trackUris)
            if (addResult.isFailure) {
                return@withContext Result.failure(addResult.exceptionOrNull()!!)
            }

            Result.success(playlist.externalUrls.spotify)
        } catch (e: Exception) {
            println("❌ Exception: ${e.message}")
            println(e.stackTraceToString())
            Result.failure(e)
        }
    }

}