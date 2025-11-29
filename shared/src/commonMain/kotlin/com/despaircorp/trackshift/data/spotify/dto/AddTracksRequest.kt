package com.despaircorp.trackshift.data.spotify.dto

import kotlinx.serialization.Serializable

@Serializable
data class AddTracksRequest(
    val uris: List<String>
)