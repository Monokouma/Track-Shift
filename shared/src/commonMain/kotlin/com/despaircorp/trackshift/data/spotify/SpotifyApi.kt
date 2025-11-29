package com.despaircorp.trackshift.data.spotify

import com.despaircorp.trackshift.data.spotify.dto.AddTracksRequest
import com.despaircorp.trackshift.data.spotify.dto.CreatePlaylistRequest
import com.despaircorp.trackshift.data.spotify.dto.SpotifyPlaylistResponse
import com.despaircorp.trackshift.data.spotify.dto.SpotifyTokenResponse
import com.despaircorp.trackshift.data.spotify.dto.SpotifyUserResponse
import com.despaircorp.trackshift.shared.BuildKonfig
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.forms.FormDataContent
import io.ktor.client.request.get
import io.ktor.client.request.header
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.Parameters
import io.ktor.http.contentType
import io.ktor.http.encodeURLParameter
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext

class SpotifyApi(
    private val httpClient: HttpClient
) {
    private var accessToken: String? = null
    private var refreshToken: String? = null

    companion object {
        val CLIENT_ID = BuildKonfig.SPOTIFY_CLIENT_ID
        val CLIENT_SECRET = BuildKonfig.SPOTIFY_SECRET_KEY
        const val REDIRECT_URI = "trackshift://spotify-callback"
        private const val AUTH_URL = "https://accounts.spotify.com/authorize"
        private const val TOKEN_URL = "https://accounts.spotify.com/api/token"
        private const val API_BASE = "https://api.spotify.com/v1"
    }

    suspend fun getAuthUrl(): String = withContext(Dispatchers.IO) {
        val scopes = "playlist-modify-public playlist-modify-private"
        return@withContext "$AUTH_URL?" +
                "client_id=$CLIENT_ID" +
                "&response_type=code" +
                "&redirect_uri=${REDIRECT_URI.encodeURLParameter()}" +
                "&scope=${scopes.encodeURLParameter()}"
    }

    fun isAuthenticated(): Boolean = accessToken != null

    fun setTokens(access: String, refresh: String?) {
        accessToken = access
        refreshToken = refresh
    }

    suspend fun exchangeCodeForToken(code: String): Result<SpotifyTokenResponse> = withContext(
        Dispatchers.IO) {
        try {
            val response = httpClient.post(TOKEN_URL) {
                contentType(ContentType.Application.FormUrlEncoded)
                setBody(FormDataContent(Parameters.build {
                    append("grant_type", "authorization_code")
                    append("code", code)
                    append("redirect_uri", REDIRECT_URI)
                    append("client_id", CLIENT_ID)
                    append("client_secret", CLIENT_SECRET)
                }))
            }

            val tokenResponse = response.body<SpotifyTokenResponse>()
            accessToken = tokenResponse.accessToken
            refreshToken = tokenResponse.refreshToken

            Result.success(tokenResponse)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun refreshAccessToken(): Result<SpotifyTokenResponse> = withContext(Dispatchers.IO) {

        val refresh = refreshToken ?: return@withContext Result.failure(Exception("No refresh token"))

        try {
            val response = httpClient.post(TOKEN_URL) {
                contentType(ContentType.Application.FormUrlEncoded)
                setBody(FormDataContent(Parameters.build {
                    append("grant_type", "refresh_token")
                    append("refresh_token", refresh)
                    append("client_id", CLIENT_ID)
                    append("client_secret", CLIENT_SECRET)
                }))
            }

            val tokenResponse = response.body<SpotifyTokenResponse>()
            accessToken = tokenResponse.accessToken
            tokenResponse.refreshToken?.let { refreshToken = it }
            Result.success(tokenResponse)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getCurrentUser(): Result<SpotifyUserResponse> = withContext(Dispatchers.IO) {
        try {
            val response = httpClient.get("$API_BASE/me") {
                header("Authorization", "Bearer $accessToken")
            }
            Result.success(response.body())
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun createPlaylist(
        userId: String,
        name: String,
        description: String = "Créée avec TrackShift"
    ): Result<SpotifyPlaylistResponse> = withContext(Dispatchers.IO) {
        try {
            val response = httpClient.post("$API_BASE/users/$userId/playlists") {
                header("Authorization", "Bearer $accessToken")
                contentType(ContentType.Application.Json)
                setBody(
                    CreatePlaylistRequest(
                        name = name,
                        public = false,
                        description = description
                    )
                )
            }
            Result.success(response.body())
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun addTracksToPlaylist(
        playlistId: String,
        trackUris: List<String>
    ): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            trackUris.chunked(100).forEach { chunk ->
                httpClient.post("$API_BASE/playlists/$playlistId/tracks") {
                    header("Authorization", "Bearer $accessToken")
                    contentType(ContentType.Application.Json)
                    setBody(AddTracksRequest(uris = chunk))
                }
            }
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}