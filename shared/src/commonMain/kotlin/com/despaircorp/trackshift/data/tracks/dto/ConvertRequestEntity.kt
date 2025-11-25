package com.despaircorp.trackshift.data.tracks.dto

data class ConvertRequestEntity(
    val toPlatform: String,
    val region: String,
    val images: List<ByteArray>
)
