package com.despaircorp.trackshift.data.spotify.dto

import kotlinx.serialization.Serializable

@Serializable
data class CreatePlaylistRequest(
    val name: String,
    val public: Boolean = false,
    val description: String = "Créée avec TrackShift"
)