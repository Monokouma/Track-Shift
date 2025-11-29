package com.despaircorp.trackshift.data.spotify.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SpotifyUserResponse(
    val id: String,
    val email: String? = null,
    @SerialName("display_name") val displayName: String? = null
)