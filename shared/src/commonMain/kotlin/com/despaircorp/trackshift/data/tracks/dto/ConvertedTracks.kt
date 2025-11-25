package com.despaircorp.trackshift.data.tracks.dto

import kotlinx.serialization.Serializable

@Serializable
data class ConvertedTrack(
    val title: String,
    val artist: String,
    val url: String,
    val thumbnailUrl: String,
    val platformId: String
)