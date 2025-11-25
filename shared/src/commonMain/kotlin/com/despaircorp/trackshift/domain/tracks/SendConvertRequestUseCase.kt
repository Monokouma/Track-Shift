package com.despaircorp.trackshift.domain.tracks

import com.despaircorp.trackshift.data.tracks.dto.ConvertRequestEntity
import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack
import com.despaircorp.trackshift.shared.BuildKonfig

class SendConvertRequestUseCase(
    private val tracksInterface: TracksInterface
) {
    suspend fun invoke(convertRequestEntity: ConvertRequestEntity): List<ConvertedTrack>? {
        println("REQUEST = $convertRequestEntity")
        return tracksInterface.convertPlaylist( BuildKonfig.API_SECRET_KEY, convertRequestEntity).getOrNull()
    }
}