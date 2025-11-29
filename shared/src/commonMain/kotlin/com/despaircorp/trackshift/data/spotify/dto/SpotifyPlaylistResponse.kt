package com.despaircorp.trackshift.data.spotify.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SpotifyPlaylistResponse(
    val id: String,
    val name: String,
    @SerialName("external_urls") val externalUrls: ExternalUrls
)

@Serializable
data class ExternalUrls(
    val spotify: String
)